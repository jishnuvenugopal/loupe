
module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    
    reg [3:0] shift_register;
    reg [1:0] counter;

    
    always @(posedge clk or posedge resetn) begin
        if (resetn == 1'b0) begin
            
            shift_register <= 4'b0000;
            counter <= 2'b00;
        end else begin
            
            counter <= counter + 1'b1;

            
            if (counter == 2'b01) begin
                shift_register <= {shift_register[2:0], in};
            end else begin
                shift_register <= shift_register;
            end
        end
    end

    
    assign out = shift_register[3];

endmodule
