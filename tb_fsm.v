`timescale 1ns / 1ps

module fsm_with_counter_tb;

    // Testbench signals
    reg clk;
    reg reset;
    reg start;
    wire done;

    // Clock period (10ns for 100 MHz)
    localparam CLOCK_PERIOD = 10;

    // Instantiate the FSM
    fsm_with_counter uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .done(done)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #(CLOCK_PERIOD / 2) clk = ~clk;  // 100 MHz clock
    end

    // Stimulus generation
    initial begin
        // Initialize signals
        reset = 1;
        start = 0;

        // Apply reset
        #(2 * CLOCK_PERIOD);
        reset = 0;

        // Wait for a few clock cycles
        #(2 * CLOCK_PERIOD);

        // Start FSM
        start = 1;
        #(CLOCK_PERIOD);
        start = 0;

        // Wait until 'done' is asserted
        wait (done == 1);
        
        // Check if FSM returns to IDLE
        #(2 * CLOCK_PERIOD);

        // Reset again
        reset = 1;
        #(2 * CLOCK_PERIOD);
        reset = 0;

        // Start FSM again to observe repeated behavior
        #(2 * CLOCK_PERIOD);
        start = 1;
        #(CLOCK_PERIOD);
        start = 0;

        // Wait until 'done' is asserted again
        wait (done == 1);

        // End simulation
        #(2 * CLOCK_PERIOD);
        $stop;
    end

endmodule


