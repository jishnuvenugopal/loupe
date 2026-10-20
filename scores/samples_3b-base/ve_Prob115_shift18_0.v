
module TopModule (
    input  clk,
    input  load,
    input  ena,
    input  [1:0] amount,
    input  [63:0] data,
    output reg [63:0] q
);

    
    reg [63:0] shift_register;

    
    always @(posedge clk) begin
        if (load) begin
            
            shift_register <= data;
        end else if (ena) begin
            
            case (amount)
                2'b00: 
                    shift_register <= {shift_register[63:1], shift_register[0]};
                2'b01: 
                    shift_register <= {shift_register[55:0], shift_register[63:56]};
                2'b10: 
                    shift_register <= {shift_register[1], shift_register[63:0]};
                2'b11: 
                    shift_register <= {shift_register[63:56], shift_register[55:0]};
                default: 
                    shift_register <= shift_register;
            endcase
        end
    end

    
    assign q = shift_register;

endmodule
