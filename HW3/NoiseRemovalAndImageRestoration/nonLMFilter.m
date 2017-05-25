function out = nonLMFilter(im,t,f,h)
    
    [m,n]=size(im);
    out=zeros(m,n);
    
    %pad zeros to boundaries
    input2=padarray(im, [f f], 'symmetric');
    
    %Used kernel
    kernel = make_kernel(f);
    kernel = kernel / sum(kernel(:));
    
    h=h^2;
    for i=1:m
        for j=1:n
            i1=i+f;
            j1=j+f;
            W1=input2(i1-f:i1+f, j1-f:j1+f);
            wmax=0;
            average=0;
            sweight=0;
            rmin=max(i1-t,f+1);
            rmax=min(i1+t,m+f);
            smin=max(j1-t,f+1);
            smax=min(j1+t,n+f);
            for r=rmin:rmax
                for s=smin:smax
                    if(r==i1 && s==j1)
                        continue;
                    end
                    W2 = input2(r-f:r+f, s-f:s+f);
                    d = sum(sum(kernel.*(W1-W2).*(W1-W2)));
                    w=exp(-d/h);
                    if w>wmax
                        wmax=w;
                    end
                    
                    average=average+w*input2(r,s);
                    sweight=sweight+w;
                end
            end
            average=average+wmax*input2(i1,j1);
            sweight=sweight+wmax;
            if sweight>0
                out(i,j)=average/sweight;
            else
                out(i,j)=im(i,j);
            end
        end
    end
end

function [kernel] = make_kernel(f)
    kernel=zeros(2*f+1,2*f+1);   
    for d=1:f    
        value= 1 / (2*d+1)^2 ;    
        for i=-d:d
          for j=-d:d
            kernel(f+1-i,f+1-j)= kernel(f+1-i,f+1-j) + value ;
          end
        end
    end
    kernel = kernel ./ f;
end
