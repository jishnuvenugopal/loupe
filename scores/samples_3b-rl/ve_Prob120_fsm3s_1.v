
module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    
    reg [1:0] state;

    
    assign out = (state == 2'b11 && in) ? 1'b1 : 1'b0;

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
 
        end else begin
            case (state)
                2'b00: begin 
                    if (in == 1'b0) begin
                        state <= 2'b00;
 
                    end else begin
                        state <= 2'b01;
 
                    end
                end
                2'b01: begin 
                    if (in == 1'b0) begin
                        state <= 2'b00;
 
                    end else begin
                        state <= 2'b10;
 
                    end
                end
                2'b10: begin 
                    if (in == 1'b0) begin
                        state <= 2'b00;
 
                    end else begin
                        state <= 2'b11;
 
                    end
                end
                2'b11: begin 
                    if (in == 1'b0) begin
                        state <= 2'b00;
 
                    end else begin
                        state <= 2'b10;
 
                    end
                end
            endcase
        end
    end

endmodule
