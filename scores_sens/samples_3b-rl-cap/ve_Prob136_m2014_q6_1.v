
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire w,
    output reg  z
);

    
    reg [2:0] state;

    
    
    
    reg [3:0] output_map = 4'b0000;

    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b000;
            output_map <= 4'b0000;
        end else begin
            case (state)
                3'b000: begin
                    if (w == 1'b0) state <= 3'b001;
 
                    else         state <= 3'b000;
 
                    output_map <= 4'b0001;
 
                end
                3'b001: begin
                    if (w == 1'b0) state <= 3'b010;
 
                    else         state <= 3'b001;
 
                    output_map <= 4'b0010;
 
                end
                3'b010: begin
                    if (w == 1'b0) state <= 3'b011;
 
                    else         state <= 3'b010;
 
                    output_map <= 4'b0011;
 
                end
                3'b011: begin
                    if (w == 1'b0) state <= 3'b100;
 
                    else         state <= 3'b011;
 
                    output_map <= 4'b0100;
 
                end
                3'b100: begin
                    if (w == 1'b0) state <= 3'b101;
 
                    else         state <= 3'b100;
 
                    output_map <= 4'b0101;
 
                end
                3'b101: begin
                    if (w == 1'b0) state <= 3'b110;
 
                    else         state <= 3'b101;
 
                    output_map <= 4'b0110;
 
                end
                default: begin
                    state <= 3'b000;
                    output_map <= 4'b0000;
                end
            endcase
        end
    end

    
    always @(*) begin
        case (state)
            3'b000: z = output_map[0];
            3'b001: z = output_map[1];
            3'b010: z = output_map[2];
            3'b011: z = output_map[3];
            3'b100: z = output_map[4];
            3'b101: z = output_map[5];
            3'b110: z = output_map[6];
            default: z = 1'b0;
        endcase
    end

endmodule
