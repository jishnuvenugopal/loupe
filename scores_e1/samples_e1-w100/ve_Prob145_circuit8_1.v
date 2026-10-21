
module TopModule (
    input wire clock,
    input wire a,
    output reg p,
    output reg q
);

    
    reg [1:0] ff;

    
    always @(posedge clock) begin
        if (ff == 2'b00) begin
            ff <= 2'b01;
 
        end else begin
            ff <= 2'b00;
 
        end
    end

    
    always @(posedge clock) begin
        if (a == 1'b1) begin
            p <= 1'b0;
 
            q <= 1'b1;
 
        end else begin
            p <= ff[0];
 
            q <= ff[1];
 
        end
    end

endmodule
