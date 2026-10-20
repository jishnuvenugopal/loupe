
module TopModule (
    input clk,
    input areset,

    input predict_valid,
    input [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

    
    reg [1:0] pht [0:127];

    
    reg [6:0] history_reg;

    
    wire [6:0] index_predict = predict_pc ^ history_reg;

    
    assign predict_taken = pht[index_predict][1];
    assign predict_history = history_reg;

    
    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            
            for (i = 0;
 i < 128;
 i = i + 1)
                pht[i] <= 2'b00;
            history_reg <= 7'd0;
        end else begin
            if (train_valid) begin
                
                reg [6:0] index_train;
                index_train = train_pc ^ train_history;

                
                if (train_taken) begin
                    if (pht[index_train] != 2'b11)
                        pht[index_train] <= pht[index_train] + 1;
                end else begin
                    if (pht[index_train] != 2'b00)
                        pht[index_train] <= pht[index_train] - 1;
                end

                
                history_reg <= {history_reg[5:0], train_taken};
            end
        end
    end

endmodule
