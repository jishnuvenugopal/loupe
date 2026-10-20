
module TopModule (
    input  wire [6:0] y,   
    input  wire       w,   
    output wire       Y1,  
    output wire       Y3   
);

    
    reg [5:0] state;

    
    always @(*) begin
        case (state)
            6'b000001: begin 
                if (y[1] == 1'b0) state = 6'b000010;
 
                else              state = 6'b000001;
 
            end
            6'b000010: begin 
                if (y[1] == 1'b0) state = 6'b000100;
 
                else              state = 6'b000010;
 
            end
            6'b000100: begin 
                if (y[1] == 1'b0) state = 6'b001000;
 
                else              state = 6'b000100;
 
            end
            6'b001000: begin 
                if (y[1] == 1'b0) state = 6'b010000;
 
                else              state = 6'b001000;
 
            end
            6'b010000: begin 
                if (y[1] == 1'b0) state = 6'b010000;
 
                else              state = 6'b001000;
 
            end
            6'b100000: begin 
                if (y[1] == 1'b0) state = 6'b000100;
 
                else              state = 6'b001000;
 
            end
            default: state = 6'b000001;
 
        endcase
    end

    
    assign Y1 = state[0];
      
    assign Y3 = state[2];
      

    

endmodule
