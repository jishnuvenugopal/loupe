
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire s,
    input  wire w,
    output reg  z
);

    
    typedef enum {A, B} state_t;
    reg state;

    
    reg [2:0] w_count;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_count <= 3'd0;
            z <= 1'b0;
        end else begin
            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                    end
                end
                B: begin
                    if (w_count == 3'd3) begin
                        
                        w_count <= 3'd0;
                    end else begin
                        if (w) begin
                            w_count <= w_count + 3'd1;
                        end
                    end
                    
                    if (w_count == 3'd2) begin
                        z <= 1'b1;
                    end else begin
                        z <= 1'b0;
                    end
                end
                default: begin
                    state <= A;
                    w_count <= 3'd0;
                    z <= 1'b0;
                end
            endcase
        end
    end

endmodule
