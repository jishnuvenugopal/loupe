
module TopModule (
    input clk,
    input a,
    output q
);

    
    reg q = 0;

    
    reg [1:0] state = 2'b00;
 

    always @(posedge clk) begin
        
        if (state == 2'b00) begin
            if (a == 1) begin
                state <= 2'b01;
 
            end else begin
                state <= 2'b00;
 
            end
        end else if (state == 2'b01) begin
            if (a == 0) begin
                state <= 2'b00;
 
            end else begin
                state <= 2'b10;
 
            end
        end else if (state == 2'b10) begin
            if (a == 1) begin
                state <= 2'b11;
 
            end else begin
                state <= 2'b10;
 
            end
        end else if (state == 2'b11) begin
            if (a == 0) begin
                state <= 2'b10;
 
            end else begin
                state <= 2'b00;
 
            end
        end
    end

    
    assign q = state[1];

endmodule
