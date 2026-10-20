
module TopModule (
    input  wire        clk,
    input  wire        rst,
    input  wire [5:0]  y,
    input  wire        w,
    output reg         Y1,
    output reg         Y3
);

    
    reg [5:0] state;

    
    assign Y1 = state[1];
    assign Y3 = state[3];

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            state <= 6'b0;
        end else begin
            case (state)
                6'b000001: begin 
                    if (w) begin
                        state <= 6'b000010;
 
                    end else begin
                        state <= 6'b000001;
 
                    end
                end
                6'b000010: begin 
                    if (w) begin
                        state <= 6'b000100;
 
                    end else begin
                        state <= 6'b000010;
 
                    end
                end
                6'b000100: begin 
                    if (w) begin
                        state <= 6'b001000;
 
                    end else begin
                        state <= 6'b000100;
 
                    end
                end
                6'b001000: begin 
                    if (w) begin
                        state <= 6'b010000;
 
                    end else begin
                        state <= 6'b000001;
 
                    end
                end
                6'b010000: begin 
                    if (w) begin
                        state <= 6'b010000;
 
                    end else begin
                        state <= 6'b000010;
 
                    end
                end
                6'b100000: begin 
                    if (w) begin
                        state <= 6'b000100;
 
                    end else begin
                        state <= 6'b000010;
 
                    end
                end
                default: state <= 6'b000001;
 
            endcase
        end
    end

endmodule
