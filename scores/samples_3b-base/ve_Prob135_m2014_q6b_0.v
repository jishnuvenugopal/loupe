
module TopModule (
    input  y[2:0],  
    input  w,       
    output Y1       
);

    
    localparam A = 3'b000;
    localparam B = 3'b001;
    localparam C = 3'b010;
    localparam D = 3'b011;
    localparam E = 3'b100;
    localparam F = 3'b101;

    
    reg [2:0] y_next;
  
    reg [2:0] y_reg;
   

    
    always @(posedge w) begin
        case (y_reg[2:1])
            A: begin
                if (w) y_next[2:1] = A;
                else y_next[2:1] = B;
            end
            B: begin
                if (w) y_next[2:1] = A;
                else y_next[2:1] = C;
            end
            C: begin
                if (w) y_next[2:1] = D;
                else y_next[2:1] = E;
            end
            D: begin
                if (w) y_next[2:1] = A;
                else y_next[2:1] = F;
            end
            E: begin
                if (w) y_next[2:1] = E;
                else y_next[2:1] = D;
            end
            F: begin
                if (w) y_next[2:1] = C;
                else y_next[2:1] = D;
            end
        endcase
    end

    
    always @(posedge w) begin
        y_reg <= y_next;
    end

    
    assign Y1 = y_reg[1];

endmodule
