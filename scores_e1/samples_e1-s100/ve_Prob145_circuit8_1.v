
module TopModule (
    input wire clock,
    input wire a,
    output reg p,
    output reg q
);

    
    reg [1:0] ff;

    
    always @(posedge clock or negedge reset) begin
        if (reset) begin
            ff <= 2'b00;
        end else begin
            ff <= a;
        end
    end

    
    always @(posedge clock) begin
        if (ff == 2'b00) begin
            p <= 1'b0;
            q <= 1'b0;
        end else if (ff == 2'b01) begin
            p <= 1'b0;
            q <= 1'b1;
        end else if (ff == 2'b10) begin
            p <= 1'b1;
            q <= 1'b0;
        end else if (ff == 2'b11) begin
            p <= 1'b1;
            q <= 1'b1;
        end
    end

endmodule
