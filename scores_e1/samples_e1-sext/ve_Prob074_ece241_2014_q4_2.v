
module TopModule (
    input clk,
    input x,
    output reg z
);

    
    reg [1:0] d0, d1;

    
    reg [1:0] state;

    
    reg [1:0] xor_out, and_out, or_out;

    
    reg [1:0] xnor_out;

    
    initial begin
        state = 2'b00;
        d0 = 2'b00;
        d1 = 2'b00;
        z = 1'b0;
    end

    
    always @(posedge clk) begin
        case (state)
            2'b00: begin
                
                xor_out = {d0, x};
                
                and_out = {d0, ~d0};
                
                or_out = {d0, ~d0};
                
                xnor_out = {xor_out, and_out, or_out};
                
                d0 <= xor_out;
                d1 <= and_out;
            end
            2'b01: begin
                
                xor_out = {d1, x};
                
                and_out = {d1, ~d1};
                
                or_out = {d1, ~d1};
                
                xnor_out = {xor_out, and_out, or_out};
                
                d0 <= xor_out;
                d1 <= and_out;
            end
            2'b10: begin
                
                xor_out = {d0, x};
                
                and_out = {d0, ~d0};
                
                or_out = {d0, ~d0};
                
                xnor_out = {xor_out, and_out, or_out};
                
                d0 <= xor_out;
                d1 <= and_out;
            end
            2'b11: begin
                
                xor_out = {d1, x};
                
                and_out = {d1, ~d1};
                
                or_out = {d1, ~d1};
                
                xnor_out = {xor_out, and_out, or_out};
                
                d0 <= xor_out;
                d1 <= and_out;
            end
        endcase
        
        z <= xnor_out;
    end

endmodule
