
module TopModule (
    input wire clk,
    input wire areset,
    input wire x,
    output reg z
);

    
    localparam  RESET = 2'b00,
                READ_INPUT = 2'b01,
                COMPUTE_2SC = 2'b10,
                OUTPUT_2SC = 2'b11,
                DONE = 2'b00;

    reg [1:0] state, next_state;
    reg [7:0] input_reg, output_reg;
    reg [2:0] count;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= RESET;
        end else begin
            state <= next_state;
        end
    end

    
    always @(*) begin
        case (state)
            RESET: begin
                if (!areset)
                    next_state = READ_INPUT;
                else
                    next_state = RESET;
            end
            READ_INPUT: begin
                if (count < 8)
                    next_state = READ_INPUT;
                else
                    next_state = COMPUTE_2SC;
            end
            COMPUTE_2SC: begin
                next_state = OUTPUT_2SC;
            end
            OUTPUT_2SC: begin
                next_state = DONE;
            end
            DONE: begin
                next_state = RESET;
            end
            default: next_state = RESET;
        endcase
    end

    
    always @(*) begin
        case (state)
            RESET: begin
                count = 3'b000;
                input_reg = 8'b00000000;
                output_reg = 8'b00000000;
                z = 1'b0;
            end
            READ_INPUT: begin
                if (count < 8)
                    input_reg[count] = x;
                count = count + 1;
            end
            COMPUTE_2SC: begin
                
                output_reg = ~input_reg + 1;
            end
            OUTPUT_2SC: begin
                z = output_reg[7];
            end
            DONE: begin
                
            end
            default: begin
                state = RESET;
            end
        endcase
    end

endmodule
