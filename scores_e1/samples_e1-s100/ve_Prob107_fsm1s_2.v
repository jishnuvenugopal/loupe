
module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    
    reg [1:0] state;
    reg out_reg;

    
    initial begin
        state = 2'b00;
        out_reg = 1'b1;
 
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00;
            out_reg <= 1'b1;
 
        end else begin
            case (state)
                2'b00: begin
                    if (in == 0) begin
                        state <= 2'b01;
                        out_reg <= 1'b0;
 
                    end else begin
                        state <= 2'b00;
                        out_reg <= 1'b1;
 
                    end
                end
                2'b01: begin
                    if (in == 0) begin
                        state <= 2'b00;
                        out_reg <= 1'b0;
 
                    end else begin
                        state <= 2'b01;
                        out_reg <= 1'b0;
 
                    end
                end
                default: begin
                    state <= 2'b00;
                    out_reg <= 1'b1;
 
                end
            endcase
        end
    end

    
    assign out = out_reg;

endmodule
