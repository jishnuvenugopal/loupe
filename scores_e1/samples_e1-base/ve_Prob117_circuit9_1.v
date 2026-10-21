
module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

    
    reg [1:0] state = 2'b00;
 

    always @(posedge clk) begin
        
        case (state)
            2'b00: begin
                if (a) begin
                    state <= 2'b01;
 
                end else begin
                    state <= 2'b00;
 
                end
            end
            2'b01: begin
                if (a) begin
                    state <= 2'b10;
 
                end else begin
                    state <= 2'b01;
 
                end
            end
            2'b10: begin
                if (a) begin
                    state <= 2'b11;
 
                end else begin
                    state <= 2'b10;
 
                end
            end
            2'b11: begin
                if (a) begin
                    state <= 2'b00;
 
                end else begin
                    state <= 2'b11;
 
                end
            end
        endcase

        
        q <= state;
    end

endmodule
