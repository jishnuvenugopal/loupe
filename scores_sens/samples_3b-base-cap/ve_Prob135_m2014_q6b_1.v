
module TopModule (
    input  y[2:0],  
    input  w,       
    output Y1       
);

    
    reg [2:0] current_state;
    reg [2:0] next_state;

    
    always @(*) begin
        case (current_state)
            3'b000: begin
                if (y[1] == 1'b0) next_state = 3'b001;
 
                else next_state = 3'b000;
 
            end
            3'b001: begin
                if (y[1] == 1'b0) next_state = 3'b010;
 
                else next_state = 3'b001;
 
            end
            3'b010: begin
                if (y[1] == 1'b0) next_state = 3'b011;
 
                else next_state = 3'b010;
 
            end
            3'b011: begin
                if (y[1] == 1'b0) next_state = 3'b100;
 
                else next_state = 3'b011;
 
            end
            3'b100: begin
                if (y[1] == 1'b0) next_state = 3'b101;
 
                else next_state = 3'b011;
 
            end
            3'b101: begin
                if (y[1] == 1'b0) next_state = 3'b010;
 
                else next_state = 3'b011;
 
            end
        endcase
    end

    
    always @(posedge w) begin
        current_state <= next_state;
    end

    
    assign Y1 = current_state[1];

endmodule
