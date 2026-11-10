
module TopModule (
    input wire clk,
    input wire areset,

    input wire predict_valid,
    input wire [6:0] predict_pc,
    output reg predict_taken,
    output reg predict_history,

    input wire train_valid,
    input wire train_taken,
    input wire train_mispredicted,
    input wire [6:0] train_history,
    input wire [6:0] train_pc
);

    
    reg [6:0] pc;
    reg [6:0] global_history;

    
    reg [6:0] index;

    
    reg [1:0] table [0:127];

    
    reg [6:0] branch_history;

    
    reg [1:0] pht [0:127];

    
    reg reset;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            pc <= 7'b0;
            global_history <= 7'b0;
            index <= 7'b0;
            table <= 128'b0;
            branch_history <= 7'b0;
            pht <= 128'b0;
            reset <= 1'b1;
        end else begin
            reset <= 1'b0;
        end
    end

    
    always @(posedge clk) begin
        if (predict_valid) begin
            
            index <= pc ^ global_history;

            
            table[index] <= table[index] + 1'b1;

            
            if (table[index] == 2'b11) begin
                branch_history <= branch_history + 1'b1;
            end

            
            if (table[index] == 2'b10) begin
                predict_taken <= 1'b1;
            end else begin
                predict_taken <= 1'b0;
            end

            
            global_history <= global_history + 1'b1;
        end
    end

    
    always @(posedge clk) begin
        if (train_valid) begin
            
            index <= pc ^ train_history;

            
            table[index] <= table[index] + 1'b1;

            
            if (train_taken) begin
                pht[index] <= 2'b11;
            end else begin
                pht[index] <= 2'b00;
            end

            
            if (train_mispredicted) begin
                branch_history <= branch_history + 1'b1;
            end
        end
    end

endmodule
