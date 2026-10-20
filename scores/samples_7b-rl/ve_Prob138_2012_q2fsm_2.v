
module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    parameter A = 0, B = 1, C = 2, D = 3, E = 4, F = 5;
    reg [2:0] current_state, next_state;

    
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    
    always @* begin
        next_state = current_state;
 
        case (current_state)
            A: if (w == 0) begin
                
                next_state = 1;
 
            end
            
            B: if (w == 0) begin
                
                next_state = 1;
 
            end
            
            C: if (w == 0) begin
                
                next_state = 2;
 

Wait, in code:

If after a state:

For example, B transitions: when in B and w=0, the code must choose between C or D based on arrows.

Thus, in code:

case (current_state)
A:
    if (w ==0) begin
        next_state = (1) ? B : A;
 
    end

Similarly:

B: begin
    if (w ==0) begin
        next_state = (1) ? C : D;
 

Thus:



    always @* begin
        next_state = current_state;
 
        case (current_state)
            A: begin
                if (w == 0)
                    next_state = (1) ? B : A;
 
            end
            B: begin
                if (w == 0)
                    next_state = (1) ? C : D;
 
            end
            C: begin
                if (w == 0)
                    next_state = (1) ? E : D;
 
            end
            D: begin
                if (w == 0)
                    next_state = (1) ? F : A;
 
            end
            E: begin
                if (w == 1)
                    next_state = (1) ? E : D;
 
            end
            F: begin
                if (w == 1)
                    next_state = (1) ? C : D;
 
            end
        endcase
    end




    assign z = (current_state == C) ? 1'b1 : 1'b0;

endmodule
