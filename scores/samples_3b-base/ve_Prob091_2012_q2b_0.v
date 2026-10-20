
module TopModule (
    input  y[5:0],  
    input  w,       
    output Y1,      
    output Y3       
);

    
    localparam A = 6'b000001;
    localparam B = 6'b000010;
    localparam C = 6'b000100;
    localparam D = 6'b001000;
    localparam E = 6'b010000;
    localparam F = 6'b100000;

    
    always @(*) begin
        case (y)
            A: begin
                if (w) next_state = B;
                else next_state = A;
            end
            B: begin
                if (w) next_state = C;
                else next_state = D;
            end
            C: begin
                if (w) next_state = E;
                else next_state = D;
            end
            D: begin
                if (w) next_state = F;
                else next_state = A;
            end
            E: begin
                if (w) next_state = E;
                else next_state = D;
            end
            F: begin
                if (w) next_state = C;
                else next_state = D;
            end
            default: next_state = A;
 
        endcase
    end

    
    reg [5:0] state_reg;
    always @(posedge w) begin
        state_reg <= next_state;
    end

    
    assign Y1 = state_reg[1];
    assign Y3 = state_reg[3];

endmodule
