import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles
import math

# Helper to convert float to signed Q29 representation (1.0 = 2^29)
def to_q29(val):
    v = int(val * (2**29))
    # Saturate
    if v > 2**31 - 1: v = 2**31 - 1
    elif v < -2**31: v = -2**31
    # Convert to 32-bit unsigned for cocotb assignment
    if v < 0:
        v = (1 << 32) + v
    return v

# Helper to convert signed Q29 representation to float
def from_q29(val):
    if val & (1 << 31):
        val -= (1 << 32)
    return val / (2**29)

@cocotb.test()
async def test_cordic_rotation(dut):
    """Test CORDIC rotation mode for various valid angles."""
    
    # Start clock (100 MHz)
    clock = Clock(dut.CLK, 10, units="ns")
    cocotb.start_soon(clock.start())
    
    # Initialize inputs
    dut.START.value = 0
    dut.rst.value = 1
    dut.X.value = 0
    dut.Y.value = 0
    dut.Z.value = 0
    
    await ClockCycles(dut.CLK, 5)
    dut.rst.value = 0
    await ClockCycles(dut.CLK, 5)
    
    # CORDIC Gain for 30 iterations is ~1.646760258
    # To compute cos(Z) and sin(Z), we input X = 1/Gain, Y = 0
    # Because we are using Q29, we can safely represent 1.0 without overflow.
    gain = 1.646760258121
    x_in = 1.0 / gain
    
    # Test angles in radians. 
    # Must be within convergence domain [-1.74, 1.74).
    test_angles = [0.0, 0.5, -0.5, 0.785398, -0.785398, 1.5, -1.5]
    
    for angle in test_angles:
        # Provide inputs
        dut.X.value = to_q29(x_in)
        dut.Y.value = 0
        dut.Z.value = to_q29(angle)
        
        # 1-cycle START pulse
        dut.START.value = 1
        await RisingEdge(dut.CLK)
        dut.START.value = 0
        
        # Wait for done signal (pulse)
        await RisingEdge(dut.done)
        
        # The outputs X_out, Y_out, Z_out are registered and updated on the same clock 
        # edge that sets done=1. In cocotb, after await RisingEdge(dut.done), 
        # the values are safe to read.
        await cocotb.triggers.ReadOnly()
        
        # Read outputs
        x_out = from_q29(int(dut.X_out.value))
        y_out = from_q29(int(dut.Y_out.value))
        z_out = from_q29(int(dut.Z_out.value))
        
        # Calculate Expected
        expected_x = math.cos(angle)
        expected_y = math.sin(angle)
        
        dut._log.info(f"Tested Angle: {angle:8.4f} rad")
        dut._log.info(f"Expected X: {expected_x:8.6f} | Actual X: {x_out:8.6f}")
        dut._log.info(f"Expected Y: {expected_y:8.6f} | Actual Y: {y_out:8.6f}")
        dut._log.info(f"Remaining Z: {z_out:8.6f}\n")
        
        # Check tolerances (Should be very accurate for 30 iterations)
        assert abs(x_out - expected_x) < 0.0001, "X output mismatch"
        assert abs(y_out - expected_y) < 0.0001, "Y output mismatch"
        
        await ClockCycles(dut.CLK, 2)
