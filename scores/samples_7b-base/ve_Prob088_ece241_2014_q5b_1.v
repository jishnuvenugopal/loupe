
module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

    
    reg [1:0] state;

    
    
    localparam A = 2'b10;
    localparam B = 2'b01;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            
            state <= A;
        end else begin
            
            case (state)
                A: state <= x ? B : A;
                B: state <= x ? A : B;
                default: state <= A;
  
            endcase
        end
    end

    
    always @(*) begin
        case ({state, x})
            {A, 1'b0}: z = 1'b0;
            {A, 1'b1}: z = 1'b1;
            {B, 1'b0}: z = 1'b1;
            {B, 1'b1}: z = 1'b0;
            default: z = 1'b0;
  
        endcase
    end

endmodule
