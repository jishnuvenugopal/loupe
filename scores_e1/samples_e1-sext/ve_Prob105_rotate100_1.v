
module TopModule (
    input wire clk,
    input wire load,
    input wire [1:0] ena,
    input wire [99:0] data,
    output reg [99:0] q
);

    
    reg [1:0] counter;

    
    reg [99:0] reg_state;

    
    initial begin
        counter = 2'b00;
    end

    
    always @(posedge clk) begin
        
        if (load) begin
            reg_state = data;
        end

        
        case (ena)
            2'b01: begin
                
                reg_state = {reg_state[99], reg_state[98:0]};
            end
            2'b10: begin
                
                reg_state = {reg_state[1:99], reg_state[0]};
            end
            2'b00: begin
                
                reg_state = reg_state;
            end
            2'b11: begin
                
                reg_state = reg_state;
            end
        endcase

        
        q = reg_state;
    end

endmodule
