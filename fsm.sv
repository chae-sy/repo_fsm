module fsm_with_counter (
    input wire clk,         // Clock signal
    input wire reset,       // Reset signal (active high)
    input wire start,       // Start signal
    output reg done         // Done signal (indicates end of process)
);

    // Parameters
    localparam COUNTER_MAX = 4;  // Maximum count for EXECUTE state

    // Define the states
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        LOAD = 2'b01,
        EXECUTE = 2'b10,
        DONE = 2'b11
    } state_t;

    // State, counter, and next state declarations
    state_t state;
    reg [2:0] counter;  // 3-bit counter to count up to COUNTER_MAX

    // Unified state, counter, and output logic (sequential block)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;     // Reset to IDLE state
            counter <= 3'b0;   // Reset the counter
            done <= 1'b0;      // Reset the done signal
        end else begin
            // Default output values
            done <= 1'b0;

            // State transitions and actions
            case (state)
                IDLE: begin
                    counter <= 3'b0;  // Reset counter in IDLE
                    if (start)
                        state <= LOAD;
                end
                
                LOAD: begin
                    state <= EXECUTE;
                end
                
                EXECUTE: begin
                    if (counter >= COUNTER_MAX) begin
                        state <= DONE;
                    end else begin
                        counter <= counter + 1;  // Increment counter during EXECUTE
                    end
                end
                
                DONE: begin
                    done <= 1'b1;     // Set done signal
                    state <= IDLE;    // Return to IDLE after finishing
                end
                
                default: begin
                    state <= IDLE;  // Default state in case of error
                    counter <= 3'b0;
                end
            endcase
        end
    end

endmodule


