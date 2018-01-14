clc;
clf;
clear all;

Path = 'BAZA0/s';

K=40;
L=5;
KL = K*L;

num=200;
BWR=zeros(200,KL);
Vr=zeros(200, 1);

m=16; n=14;
mn=m*n;
BWS=zeros(mn, KL);

BIN = 32;
BWH=zeros(BIN, KL);

M=112;
N=92;

X=fix((N-5)*rand(1,num))+1;
Y=fix((M-5)*rand(1,num))+1;

figure(1); clf;

step1=0;
for k=1:K
    for l=1:L
        step1=step1+1;
        
        adr=[Path,num2str(k),'/',num2str(l),'.pgm'];
        Face=imread(adr);
        Face=double(Face)/255;
        [M,N,q] = size(Face);
        subplot(121);
        imshow(Face);
        title(['\fontsize{16}\color{yellow}Face ', num2str(k),'/',num2str(l)]);
        xlabel(['\fontsize{16}\color{yellow}',num2str([M,N,q])]);
        ylabel('\fontsize{16}\color{yellow}Baza ATT');
        hold on;
        plot(X,Y,'*y');
        hold off;
        
        miniface=imresize(Face, [m,n]);
        Vs=miniface(:);
        BWS(:, step1)=Vs;
        subplot(322);
        plot(Vs, 'r');
        grid;
        title(['\fontsize{16}\color{red}Scale']);
        
        for t=1:num
            Vr(t)=Face(Y(t),X(t));
        end;
        
        subplot(324);
        plot(Vr,'g');
        BWR(:, step1)=Vr;
        title(['\fontsize{16}\color{green}Random']);
        
        H=imhist(Face,BIN);
        BWH(:, step1)=H;
        
        subplot(326);
        bar(H, 'b');
        grid;
        title(['\fontsize{16}\color{blue}Histogram']);

        pause(.1);
    end 
end

figure(2);
clf;

subplot(311);
plot(BWS,'r');
grid;
title(['\fontsize{16}\color{red}Scale']);

subplot(312);
plot(BWR,'g');
grid;
title(['\fontsize{16}\color{green}Random']);

subplot(313);
bar(BWH,'b');
grid;
title(['\fontsize{16}\color{blue}Histogram']);

figure(3);
clf;

licznikS=0;
RS=0;

licznikR=0;
RR=0;

licznikH=0;
RH=0;

DS=zeros(KL,1);
DH=zeros(KL,1);
DR=zeros(KL,1);

step=0;

for k=1:K
    for l=L+1:10
        step=step+1;
        adr=[Path, num2str(k), '/', num2str(l), '.pgm'];
        QueryFace=imread(adr);
        QueryFace=double(QueryFace)/255;
        [M,N,q] = size(QueryFace);
        subplot(241);
        imshow(QueryFace);
        title(['\fontsize{16}\color{yellow}Face ', num2str(k), '/', num2str(l)]);
        %xlabel(['\fontsize{16}\color{yellow}',num2str([M,N,q])]);
        %ylabel('\fontsize{16}\color{yellow}Baza ATT');
        hold on;
        %plot(X,Y, '*y');
        hold off;
        
        miniface=imresize(QueryFace, [m,n]);
        Vs=miniface(:);
        %subplot(241);
        %plot(Vs, 'r');
        %grid;
        %title(['\fontsize{16}\color{red}Scale']);
        
        for t=1:num
            Vr(t)=QueryFace(Y(t),X(t));
        end;
        
        %subplot(624);
        %plot(Vr, 'g');
        %grid;
        %title(['\fontsize{16}\color{green}Random']);
        
        H=imhist(QueryFace,BIN);
        %subplot(626);
        %bar(H, 'b');
        %grid;
        %title(['\fontsize{16}\color{blue}Histogram']);
        
        for j=1:KL
            DS(j)=sum(abs(Vs-BWS(:,j)));
            DR(j)=sum(abs(Vr-BWR(:,j)));
            DH(j)=sum(abs(H-BWH(:,j)));
        end
        
        [a1,indexS]=min(DS);        
        adrS=[Path,num2str(indexS),'/1.pgm'];       
        FaceS=imread(adrS);
        subplot(242);
        imshow(FaceS);
        title(['\fontsize{16}\color{red}Scale']);
        
        if indexS == k
            licznikS = licznikS+1;
        end
        
        RRS=100*licznikS/step;
        RS(step)=RRS;
        
        [a2,indexR]=min(DR);
        adrR=[Path,num2str(indexR),'/1.pgm'];
        FaceR=imread(adrR);
        subplot(243);
        imshow(FaceR);
        title(['\fontsize{16}\color{green}Random']);
        
        if indexR == k
            licznikR =licznikR+1;
        end
        
        RRR=100*licznikR/step;
        RR(step)=RRR;
        
        [a3,indexH]=min(DH);
        adrH=[Path,num2str(indexH),'/1.pgm'];
        FaceH=imread(adrH);
        subplot(244);
        imshow(FaceH);
        title(['\fontsize{16}\color{blue}Histogram']);
        
        pause(.1);
     
        if indexH == k
            licznikH =licznikH+1;
        end
        
        RRH=100*licznikH/step;
        RH(step)=RRH;
        
        subplot(212);
        
        hold on;
        plot(RS','r')
        
        subplot(212);
        hold on;
        plot(RR','g')
        
        subplot(212);
        hold on;
        plot(RH','b')
        
        title(['\fontsize{16}\color{red}Scale: ',num2str(sprintf('%0.2f',RRS)), '% \fontsize{16}\color{green}Random: ', num2str(sprintf('%0.2f',RRR)), '% \fontsize{16}\color{blue}Histogram: ', num2str(sprintf('%0.2f',RRH)), '%'])
        legend('scale','random','histogram')

        grid;
    end
end
