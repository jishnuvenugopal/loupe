
module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    
    reg [99:0] reg_state;
    reg [1:0] rotation_direction;
    reg [1:0] rotation_counter;

    
    initial begin
        rotation_direction = 2'b01;
 
        rotation_counter = 0;
    end

    
    always @(posedge clk) begin
        if (load) begin
            reg_state = data;
            rotation_direction = 2'b01;
 
            rotation_counter = 0;
        end else begin
            if (ena == 2'b01) begin
                
                reg_state = {reg_state[99], reg_state[98:0]};
                rotation_counter = (rotation_counter + 1) % 2;
            end else if (ena == 2'b10) begin
                
                reg_state = {reg_state[1:0], reg_state[99:1]};
                rotation_counter = (rotation_counter + 1) % 2;
            end
        end
    end

    
    always @(posedge clk) begin
        if (rotation_counter == 0) begin
            q = reg_state;
        end
    end

endmodule
