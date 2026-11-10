
module JC_counter (
    input wire clk,
    input wire rst_n,
    output reg [63:0] Q
);

    
    reg [1:0] state;
    reg [63:0] current_value;

    
    initial begin
        state = 2'b00;
        current_value = 64'b0;
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 2'b00;
            current_value <= 64'b0;
        end else begin
            case (state)
                2'b00: begin
                    
                    state <= 2'b01;
                    current_value <= 64'b0;
                end
                2'b01: begin
                    
                    if (current_value[0] == 1'b0) begin
                        current_value = current_value >> 1;
                        current_value[63] = 1'b1;
                    end else begin
                        current_value = current_value >> 1;
                        current_value[63] = 1'b0;
                    end
                    state <= 2'b00;
                end
                default: begin
                    
                    state <= 2'b00;
                    current_value <= 64'b0;
                end
            endcase
        end
    end

    
    assign Q = current_value;

endmodule
