
module TopModule (
    input clk,
    input ar,
    input d,
    output q
);

    
    reg [1:0] state;

    
    always @(posedge clk or posedge ar) begin
        if (ar) begin
            state <= 2'b00;
 
        end else begin
            if (state == 2'b00) begin
                state <= 2'b01;
 
            end else begin
                state <= 2'b00;
 
            end
        end
    end

    
    assign q = state[0];

endmodule
