
module TopModule (
    input  clk,
    input  load,
    input  ena,
    input  [1:0] amount,
    input  [63:0] data,
    output reg [63:0] q
);

    
    reg [63:0] reg_array;

    
    always @(posedge clk or posedge load) begin
        if (load) begin
            reg_array <= data;
        end
    end

    
    always @(posedge clk or posedge ena) begin
        if (ena) begin
            
            reg [1:0] shift_dir = amount[1:0];
            reg [3:0] shift_amount = amount[3:0];

            
            case (shift_dir)
                2'b00: 
                    reg_array <= {reg_array[62:0], reg_array[63]};
                2'b01: 
                    reg_array <= {reg_array[55:0], reg_array[63:56]};
                2'b10: 
                    reg_array <= {reg_array[1:0], reg_array[0]};
                2'b11: 
                    reg_array <= {reg_array[63:56], reg_array[55:0]};
            endcase
        end
    end

    
    assign q = reg_array;

endmodule
