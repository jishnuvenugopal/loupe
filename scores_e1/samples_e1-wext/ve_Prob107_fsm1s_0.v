
module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    
    reg [1:0] state;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00;
 
        end else begin
            case (state)
                2'b00: begin 
                    if (in == 0) begin
                        state <= 2'b01;
 
                    end else begin
                        state <= 2'b00;
 
                    end
                end
                2'b01: begin 
                    if (in == 0) begin
                        state <= 2'b00;
 
                    end else begin
                        state <= 2'b01;
 
                    end
                end
                default: begin 
                    state <= 2'b00;
 
                end
            endcase
        end
    end

    
    assign out = state == 2'b00 ? 1'b1 : 1'b0;

endmodule
