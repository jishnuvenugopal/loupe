
module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

    
    reg [99:0] q;

    
    reg [1:0] rot_dir;
    reg [1:0] rot_dir_next;
    reg [1:0] rot_dir_next_next;

    
    reg load_next;

    
    always @(posedge clk or posedge load) begin
        load_next <= load;
        rot_dir_next <= rot_dir;
        rot_dir_next_next <= rot_dir;

        if (load_next) begin
            rot_dir_next <= 2'b01;
 
        end else if (ena[1]) begin
            rot_dir_next <= 2'b10;
 
        end else if (ena[0]) begin
            rot_dir_next <= 2'b00;
 
        end else if (ena[1] && ena[0]) begin
            rot_dir_next <= 2'b11;
 
        end

        rot_dir <= rot_dir_next;
        rot_dir_next_next <= rot_dir_next;

        if (ena[1]) begin
            q <= {q[99], q[98:0]};
        end else if (ena[0]) begin
            q <= {q[1:99], q[0]};
        end else if (ena[1] && ena[0]) begin
            q <= q;
        end
    end

endmodule
