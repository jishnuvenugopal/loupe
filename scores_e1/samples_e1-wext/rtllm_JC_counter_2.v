
module JC_counter (
    input wire clk,
    input wire rst_n,
    output reg [63:0] Q
);

    
    reg [63:0] current_count;
    reg [1:0] state;

    
    always @(*) begin
        current_count = 0;
        state = 0;
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_count = 0;
            state = 0;
        end else begin
            case (state)
                2'b00: begin
                    if (current_count[0] == 0) begin
                        current_count = current_count >> 1;
                        current_count[63] = 1;
                    end else begin
                        current_count = current_count >> 1;
                        current_count[63] = 0;
                    end
                end
                2'b01: begin
                    if (current_count[0] == 0) begin
                        current_count = current_count >> 1;
                        current_count[63] = 0;
                    end else begin
                        current_count = current_count >> 1;
                        current_count[63] = 1;
                    end
                end
                default: begin
                    state = 0;
                end
            endcase
        end
    end

    
    assign Q = current_count;

endmodule
