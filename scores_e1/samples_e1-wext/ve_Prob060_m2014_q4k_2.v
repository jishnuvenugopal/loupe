
module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    
    reg [3:0] shiftRegister;

    
    reg [1:0] shiftCounter;

    
    assign shiftCounter = 2'b00;

    
    always @(posedge clk or posedge resetn) begin
        if (!resetn) begin
            
            shiftRegister <= 4'b0000;
            shiftCounter <= 2'b00;
        end else begin
            
            if (shiftCounter == 2'b01) begin
                shiftRegister <= {shiftRegister[2:0], in};
                shiftCounter <= 2'b00;
            end else begin
                shiftRegister <= shiftRegister;
                shiftCounter <= shiftCounter + 1'b1;
            end
        end
    end

    
    assign out = shiftRegister[3];

endmodule
