
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
    input [6:0] train_pc,
    input [6:0] train_history
);
    reg [6:0] GHR;
    reg [6:0] GHR_prev;
    reg [1:0] PHT [0:127];
    wire [6:0] index_predict, index_train;

    
    assign index_predict = predict_pc ^ GHR_prev;
    assign predict_taken = PHT[index_predict][1];
    assign predict_history = GHR_prev;

    
    assign index_train = train_pc ^ GHR_prev;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            GHR <= 7'b0;
            GHR_prev <= 7'b0;
            
            for (integer i = 0;
 i < 128;
 i = i + 1) begin
                PHT[i] <= 2'b00;
            end
        end else begin
            
            GHR_prev <= GHR;

            if (train_valid) begin
                
                if (train_taken) begin
                    if (PHT[index_train] != 2'b11)
                        PHT[index_train] <= PHT[index_train] + 1;
                end else begin
                    if (PHT[index_train] != 2'b00)
                        PHT[index_train] <= PHT[index_train] - 1;
                end

                
                if (train_mispredicted)
                    GHR <= GHR_prev;
                else
                    GHR <= (GHR_prev << 1) | train_taken;
            end else if (predict_valid) begin
                
                GHR <= (GHR_prev << 1) | predict_taken;
            end
        end
    end
endmodule
