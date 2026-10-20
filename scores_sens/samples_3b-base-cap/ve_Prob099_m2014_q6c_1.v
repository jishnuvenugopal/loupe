
module TopModule (
    input wire y[6:0], 
    input wire w,       
    output reg Y1,      
    output reg Y3       
);

    
    reg [5:0] current_state;

    
    always @(*) begin
        case (current_state)
            6'b000001: begin
                if (w == 0) current_state = 6'b000010;
                else current_state = 6'b000001;
            end
            6'b000010: begin
                if (w == 0) current_state = 6'b000100;
                else current_state = 6'b000010;
            end
            6'b000100: begin
                if (w == 0) current_state = 6'b001000;
                else current_state = 6'b000100;
            end
            6'b001000: begin
                if (w == 0) current_state = 6'b010000;
                else current_state = 6'b001000;
            end
            6'b010000: begin
                if (w == 0) current_state = 6'b100000;
                else current_state = 6'b010000;
            end
            6'b100000: begin
                if (w == 0) current_state = 6'b000001;
                else current_state = 6'b100000;
            end
            default: current_state = 6'b000001;
 
        endcase
    end

    
    always @(*) begin
        Y1 = y[1];
        Y3 = y[3];
    end

endmodule
