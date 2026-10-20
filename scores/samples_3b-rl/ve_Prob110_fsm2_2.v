
module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire j,
    input  wire k,
    output reg  out
);

    
    reg [1:0] state;

    
    assign out = state[0];

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b00;
 
        end else begin
            
            if (state == 2'b00) begin 
                if (j == 1'b0) begin
                    state <= 2'b00;
 
                end else begin
                    state <= 2'b01;
 
                end
            end else if (state == 2'b01) begin 
                if (k == 1'b0) begin
                    state <= 2'b01;
 
                end else begin
                    state <= 2'b00;
 
                end
            end
        end
    end

endmodule
