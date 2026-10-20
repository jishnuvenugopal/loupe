
module adder_pipe_64bit (
    input        clk,
    input        rst_n,
    input        i_en,
    input  [63:0] adda,
    input  [63:0] addb,
    output reg [64:0] result,
    output reg       o_en
);

    
    reg [63:0] adda_reg [0:3];
    reg [63:0] addb_reg [0:3];
    reg [64:0] sum_reg  [0:3];
    reg [63:0] carry_reg [0:3];

    
    reg [3:0] i_en_reg;

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            i_en_reg <= 4'b0000;
        else
            i_en_reg <= {i_en_reg[2:0], i_en};
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            adda_reg <= {4{64'b0}};
            addb_reg <= {4{64'b0}};
            sum_reg  <= {4{65'b0}};
            carry_reg <= {4{64'b0}};
        end else begin
            adda_reg <= {adda_reg[1:0], adda};
            addb_reg <= {addb_reg[1:0], addb};
            sum_reg  <= {carry_reg[0], adda_reg[0] + addb_reg[0]};
            carry_reg <= {carry_reg[0], (adda_reg[0] + addb_reg[0]) > 63};
        end
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= 65'b0;
            o_en   <= 1'b0;
        end else begin
            result <= sum_reg[0];
            o_en   <= i_en_reg[0];
        end
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            adda_reg <= {4{64'b0}};
            addb_reg <= {4{64'b0}};
            sum_reg  <= {4{65'b0}};
            carry_reg <= {4{64'b0}};
        end else begin
            adda_reg <= {adda_reg[1:0], adda};
            addb_reg <= {addb_reg[1:0], addb};
            sum_reg  <= {carry_reg[1], adda_reg[1] + addb_reg[1]};
            carry_reg <= {carry_reg[1], (adda_reg[1] + addb_reg[1]) > 63};
        end
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= 65'b0;
            o_en   <= 1'b0;
        end else begin
            result <= sum_reg[1];
            o_en   <= i_en_reg[1];
        end
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            adda_reg <= {4{64'b0}};
            addb_reg <= {4{64'b0}};
            sum_reg  <= {4{65'b0}};
            carry_reg <= {4{64'b0}};
        end else begin
            adda_reg <= {adda_reg[1:0], adda};
            addb_reg <= {addb_reg[1:0], addb};
            sum_reg  <= {carry_reg[2], adda_reg[2] + addb_reg[2]};
            carry_reg <= {carry_reg[2], (adda_reg[2] + addb_reg[2]) > 63};
        end
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= 65'b0;
            o_en   <= 1'b0;
        end else begin
            result <= sum_reg[2];
            o_en   <= i_en_reg[2];
        end
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            adda_reg <= {4{64'b0}};
            addb_reg <= {4{64'b0}};
            sum_reg  <= {4{65'b0}};
            carry_reg <= {4{64'b0}};
        end else begin
            adda_reg <= {adda_reg[1:0], adda};
            addb_reg <= {addb_reg[1:0], addb};
            sum_reg  <= {carry_reg[3], adda_reg[3] + addb_reg[3]};
            carry_reg <= {carry_reg[3], (adda_reg[3] + addb_reg[3]) > 63};
        end
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= 65'b0;
            o_en   <= 1'b0;
        end else begin
            result <= sum_reg[3];
            o_en   <= i_en_reg[3];
        end
    end

endmodule
