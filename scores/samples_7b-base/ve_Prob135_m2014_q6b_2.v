
module TopModule(
    input  [2:0] y,  
    input  w,        
    output Y1        
);
    
    reg [1:0] y_reg;
    reg [2:0] y_next;

    
    assign y_reg = y[1:0];

    
    always @(*) begin
        case (y_reg)
            2'd00: y_next = (w == 1'b0) ? 3'd1 : 3'd0;
            2'd01: y_next = (w == 1'b0) ? 3'd0 : 3'd1;
            2'd10: y_next = (w == 1'b0) ? 3'd1 : 3'd1;
            2'd11: y_next = (w == 1'b0) ? 3'd0 : 3'd0;
        endcase
    end

    
    always @(posedge w or posedge y[1]) begin
        if (posedge w) begin
            y_reg <= y_next;
        end
    end

    
    assign Y1 = y_reg[1];
endmodule
