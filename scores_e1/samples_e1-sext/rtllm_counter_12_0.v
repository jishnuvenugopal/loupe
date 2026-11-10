
module counter_12 (
    input wire rst_n,
    input wire clk,
    input wire valid_count,
    output reg [3:0] out
);

    
    typedef enum {idle, counting} state_t;
    state_t state;

    
    reg [3:0] count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
            count <= 4'b0000;
        end else begin
            case (state)
                idle:
                    if (valid_count) begin
                        state <= counting;
                        count <= 4'b0000;
                    end
                counting:
                    if (count == 4'b1111) begin
                        count <= 4'b0000;
                    end else begin
                        count <= count + 1;
                    end
                default:
                    state <= idle;
            endcase
            out <= count;
        end
    end

endmodule
