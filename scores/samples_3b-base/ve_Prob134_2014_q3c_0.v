
module TopModule (
    input  x,          
    input  [2:0] y,     
    output reg Y0,      
    output reg z        
);

    
    reg [2:0] current_state;

    
    always @(posedge x or posedge y) begin
        case ({y, x})
            3'b000: current_state <= {y[2], y[1], y[0]};
            3'b001: current_state <= {y[1], y[0], y[0]};
            3'b010: current_state <= {y[0], y[0], y[1]};
            3'b011: current_state <= {y[0], y[1], y[1]};
            3'b100: current_state <= {y[1], y[1], y[0]};
            default: current_state <= {y[2], y[1], y[0]};
        endcase
    end

    
    always @(*) begin
        case (current_state)
            3'b000: Y0 <= y[0];
            3'b001: Y0 <= y[0];
            3'b010: Y0 <= y[0];
            3'b011: Y0 <= y[1];
            3'b100: Y0 <= y[1];
            default: Y0 <= y[0];
        endcase
    end

    
    always @(*) begin
        case (current_state)
            3'b000: z <= 1'b0;
            3'b001: z <= 1'b0;
            3'b010: z <= 1'b0;
            3'b011: z <= 1'b1;
            3'b100: z <= 1'b1;
            default: z <= 1'b0;
        endcase
    end

endmodule
