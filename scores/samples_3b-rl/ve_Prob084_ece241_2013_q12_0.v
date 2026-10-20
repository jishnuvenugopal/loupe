
module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    
    reg [7:0] Q;

    
    wire [2:0] ABC;

    
    assign ABC = {A, B, C};

    always @(posedge clk) begin
        
        if (enable) begin
            Q[0] <= S;
            Q[1] <= Q[0];
            Q[2] <= Q[1];
            Q[3] <= Q[2];
            Q[4] <= Q[3];
            Q[5] <= Q[4];
            Q[6] <= Q[5];
            Q[7] <= Q[6];
        end
    end

    
    reg Z_reg;

    always @(posedge clk) begin
        if (ABC == 3'b000) begin
            Z_reg <= Q[0];
        end else if (ABC == 3'b001) begin
            Z_reg <= Q[1];
        end else if (ABC == 3'b010) begin
            Z_reg <= Q[2];
        end else if (ABC == 3'b011) begin
            Z_reg <= Q[3];
        end else if (ABC == 3'b100) begin
            Z_reg <= Q[4];
        end else if (ABC == 3'b101) begin
            Z_reg <= Q[5];
        end else if (ABC == 3'b110) begin
            Z_reg <= Q[6];
        end else if (ABC == 3'b111) begin
            Z_reg <= Q[7];
        end else begin
            Z_reg <= 1'b0;
        end
    end

    assign Z = Z_reg;

endmodule
