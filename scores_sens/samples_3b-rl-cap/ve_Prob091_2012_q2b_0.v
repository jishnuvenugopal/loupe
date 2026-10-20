
module TopModule (
    input  wire [5:0] y,   
    input  wire       w,   
    output wire       Y1,  
    output wire       Y3   
);

    
    reg [5:0] y_reg;

    
    assign Y1 = y_reg[1];
    assign Y3 = y_reg[3];

    
    always @(*) begin
        case ({y_reg, w})
            
            {6'b000001, 1'b0}: y_reg = 6'b000001;
 
            {6'b000001, 1'b1}: y_reg = 6'b000010;
 

            
            {6'b000010, 1'b0}: y_reg = 6'b000010;
 
            {6'b000010, 1'b1}: y_reg = 6'b000100;
 

            
            {6'b000100, 1'b0}: y_reg = 6'b000100;
 
            {6'b000100, 1'b1}: y_reg = 6'b001000;
 

            
            {6'b001000, 1'b0}: y_reg = 6'b001000;
 
            {6'b001000, 1'b1}: y_reg = 6'b010000;
 

            
            {6'b010000, 1'b0}: y_reg = 6'b010000;
 
            {6'b010000, 1'b1}: y_reg = 6'b100000;
 

            
            {6'b100000, 1'b0}: y_reg = 6'b100000;
 
            {6'b100000, 1'b1}: y_reg = 6'b000001;
 

            default: y_reg = 6'b000001;
 
        endcase
    end

    
    always @(posedge w) begin
        y_reg <= y_reg;
    end

endmodule
