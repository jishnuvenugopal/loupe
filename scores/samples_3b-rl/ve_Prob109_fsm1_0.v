
module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output reg  out
);

    
    reg state;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b1;
 
        end else begin
            if (state == 1'b1) begin
                
                if (in) begin
                    state <= 1'b1;
 
                end else begin
                    state <= 1'b0;
 
                end
            end else begin
                
                if (in) begin
                    state <= 1'b0;
 
                end else begin
                    state <= 1'b1;
 
                end
            end
        end
    end

    
    assign out = state;

endmodule
