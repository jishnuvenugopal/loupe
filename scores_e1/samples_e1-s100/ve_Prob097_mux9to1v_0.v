
module TopModule (
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0] sel,
    output [15:0] out
);

    
    reg [15:0] selected_input;

    
    always @(posedge clk or negedge rst) begin
        if (rst) begin
            selected_input <= 16'b0;
        end else begin
            case (sel)
                4'b0000: selected_input <= a;
                4'b0001: selected_input <= b;
                4'b0010: selected_input <= c;
                4'b0011: selected_input <= d;
                4'b0100: selected_input <= e;
                4'b0101: selected_input <= f;
                4'b0110: selected_input <= g;
                4'b0111: selected_input <= h;
                4'b1000: selected_input <= i;
                default: selected_input <= 16'b11111111;
 
            endcase
        end
    end

    
    assign out = selected_input;

endmodule
