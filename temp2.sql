select left('Star Wars Imperial Star Destroyer Lego 75055 New In Box',65)

select * from V_ProductCategory where ID=143

select * from V_ProductCategory where CategoryID=18585

select * from V_ProuctCategoryDetail where CategoryID=18466

select C.CategoryName,D.* from AutoPostAdPostData D
inner join V_ProductCategory C on D.CategoryID=C.ID
where SKU like '%BS_%'

select * from V_ProductCategory where CategoryName like '%misc%'

update ProductCategory set TemplateID=2 where ID=146

delete from DropshipInventory

update ProductCategory
set TemplateID=2
where ID=143

SELECT * FROM SysObjects WHERE [xtype] = 'U '

select * from syscolumns

select * from SysObjects O inner join syscolumns C on C.ID=OBJECT_ID(O.name )

select [name] from [syscolumns] where [name] = 'AutoPostAdResult' order by [colid]

select distinct [xtype] from SysObjects

select * from account where Status='A'

select * from address

select * from CustomFieldGroup

select * from CustomFieldLine where CustomFieldGroupID in (1,23) 

select * from AutoPostAdPostData where AccountID=25

--update CustomFieldLine set FieldValue='6:00pm' where CustomFieldGroupID in (6) and FieldValue='6:00am'

select * from Template

select * from TemplateField where TemplateID in (2)

update TemplateField set DefaultValue='We Specialize End of Lease Cleaning' where ID=35



select * from V_ProductCategory where ID in (27,203,162)
select * from V_ProductCategory where CategoryID=18577
select * from CustomFieldGroup
select * from CustomFieldLine where CustomFieldGroupID in (10)
select top 100 * from AutoPostAdPostData order by ID desc
select * from AutoPostAdPostData where SKU like '%adam%'
select * from AutoPostAdPostData where SKU like '%ken%sydney%'
select * from AutoPostAdPostData where SKU in ('BS_XiaoLiu_Melbourne_Removal_1')
select * from Account where Status='A'

update D
set 
--AccountID=33
accountid=34
--customfieldgroupid=28,
--Status='A'
from AutoPostAdPostData D
where 
SKU in ('BS_Adam_Melbourne_Job_4','BS_Adam_Melbourne_Job_3','BS_Adam_Melbourne_Job_2','BS_Adam_Melbourne_Job_5')
--sku like '%ken%mel%' and 
--AdTypeID=1 and
--exists(select 1 from AutoPostAdResult where AutoPostAdDataID=D.ID)
--and Price=0
--and SKU not like '%ado%'

delete from AutoPostAdResult where AdID='1067542528'

update AutoPostAdPostData 
set Description=REPLACE(REPLACE(Description,'0422080272','0426246275'),'Kenny','David')
--set AccountID=25
--set CustomFieldGroupID=28
--where SKU like '%Ken%Sydney%'
where ID in (1896,1899,1900)

select * from AutoPostAdPostData where SKU like '%ken%sydney%'

select * from CustomFieldLine where CustomFieldGroupID in (select CustomFieldGroupID from AutoPostAdPostData where SKU like '%xiaoliu%')

select * from AutoPostAdPostData where Description like '%0405989276%'

update Account set FirstName='David',PhoneNumber='0426246275' where ID =25

update AutoPostAdPostData set Description=REPLACE(Description,'0430282812','0412025967') where Description  like '%0430282812%'

update CustomFieldLine set FieldValue='0412025967' where ID=194

--Nice garden body care Melbourne CBD massage
insert into AutoPostAdResult values(1786,getdate(),'1044679781')

--Lawn Mowing in Epping/Marsfield/Eastwood/Macquare Park&other area
insert into AutoPostAdResult values(1872,getdate(),'1044298701')

--Domestic/International Airport transfer service
insert into AutoPostAdResult values(1873,getdate(),'1044298704')

--Magic Paint repairer - Chips and scratches specialists
insert into AutoPostAdResult values(1880,getdate(),'1044298715')

--Start your own E-Business, Generate much better income
insert into AutoPostAdResult values(1881,getdate(),'1044221490')

--Touring Driver + Wagon/Bus Hiring Service Provided 24x7
insert into AutoPostAdResult values(1883,getdate(),'1044221493')

insert into AutoPostAdResult 
select ID,getdate(),'1049590844' from AutoPostAdPostData
where SKU='BS_Tom_Ken_Melbourne_Clean_9'




select * from V_ProductCategory where ID=203

select * from V_ProductCategory where CategoryID in (20013)

update ProductCategory set TemplateID=6 where ID=17

delete from ImportedAdData where SKU is null

delete from CustomFieldLine where ID in (123,124)

select * from ImportedAdData

delete from DropshipInventory

update CustomFieldGroup
set Name='Adam Job'
where ID=10

update CustomFieldLine
set FieldValue='0425198508'
where ID=122

delete from CustomFieldLine where ID=49

update ProductCategory
set TemplateID=4
from
(select * from V_ProductCategory where RootID=4) A
where A.ID=ProductCategory.ID

update account set
--UserName='TimmyKumar19800617@Yahoo.com.au',
--Password='Assignment20141021',
--FirstName='Allison',
--Cookie='uvts=30N5NYFnNlGfV6vm; __uvt=; _gali=my-nav; __utma=160852194.128165491.1430458065.1430482921.1430487245.5; __utmb=160852194.1.10.1430487245; __utmc=160852194; __utmz=160852194.1430458065.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.128165491.1430458065; optimizelyBuckets=%7B%7D; optimizelySegments=%7B%222228232520%22%3A%22safari%22%2C%222248430589%22%3A%22false%22%2C%222247230845%22%3A%22direct%22%2C%222242430639%22%3A%22none%22%7D; up=%7B%22ln%22%3A%22801168770%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%2C%22lbh%22%3A%22l%3D0%26c%3D18558%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000003dcc410b82301880e1bff21d15e2735b6e165d160606e63c24ed6c356b38367181d0afcf5387f7f8bc94903d278472211923c8728274b7c60b299bf0b5cef519470289b6fe199608aa0381f400bad5224fe1384dce6873afed27e3db1c79810c92fadc35970d383b1aa8cc630c29dccc1c6df0eb8c6201d77ee867fb17d2abd7c9ab4189766158c6aad426bef107464029c19d000000; wl=%7B%22l%22%3A%22%22%7D; __gads=ID=9cec9dd972fd27d6:T=1430458064:S=ALNI_MZEzMPCfZciWS3weuI21157Evr92w; optimizelyEndUserId=oeu1430458062363r0.8629176039248705; bs=%7B%22st%22%3A%7B%7D%7D; machId=Wtmo0Zw0f6fCC5oY6GcN9UaDL-yGXLsggxrZGig8hXby_W5XROzM8b41hQ1jhqT5ysE0Lbc3jS_wbDcQiFNawahw5C-6OanTrew'--Safari Leixi
--cookie='ki_t=1453503651690%3B1453503651690%3B1453503651690%3B1%3B1; ki_r=; ki_s=wa4; ki_u=wa4; sc=BzKsCrvvtvxAvMITPKC6; machId=e4FCpRSrCOM7uCKvV8O-ShFg9NtQcLj0y45Yq6c39ph7sbyQ6snL8bLr4IHwIjo__NpVEDazltY8OsCqfol0ibV9Y5dKXCHRfrY9; up=%7B%22ln%22%3A%22563950035%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; optimizelyEndUserId=oeu1453503645486r0.02016498341432238; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22ie%22%7D; optimizelyBuckets=%7B%7D; __utma=160852194.1946999416.1453503647.1453503647.1453503647.1; __utmb=160852194.1.10.1453503647; __utmz=160852194.1453503647.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1946999416.1453503647; _gat=1; __gads=ID=7744d716de1a8fe0:T=1453460495:S=ALNI_MbiMzOOdFmuYb2HUTJDcWSrJi1Orw; bs=%7B%22st%22%3A%7B%7D%7D; sid2=1f8b0800000000000000558e4d6f82401086ffca1ced65181616aa7b41978d9af0619404aec8876e828094d4c45fdf4d9b36f5f026f33e79323336d19213d9dc0b1823642ea1fd6ec2fd208887a7eebad2729160510db7b19cf5b96b04c4a7bd021f4940aefb7a787c40928187b6e969eeb902b249d74d3f5bdfce29929209c0446520a3233024e4e433ff1f7390a363d8f285d12f8b9b5a9720cdca66828334b7e84734afc9bf4909d8f7ed7028e72b3a02b679b10ad33c89d275a8c2b7a06da77335aa693746d596159b7b71193fad2f988651f301010000'-- WebBrowser Leixi
--cookie='ki_t=1453503651690%3B1453503651690%3B1453503651690%3B1%3B1; ki_r=; machId=e4FCpRSrCOM7uCKvV8O-ShFg9NtQcLj0y45Yq6c39ph7sbyQ6snL8bLr4IHwIjo__NpVEDazltY8OsCqfol0ibV9Y5dKXCHRfrY9; up=%7B%22ln%22%3A%22563950035%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; optimizelyEndUserId=oeu1453503645486r0.02016498341432238; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22ie%22%7D; optimizelyBuckets=%7B%7D; __utma=160852194.1946999416.1453503647.1453709736.1453715750.5; __utmz=160852194.1453503647.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1946999416.1453503647; __gads=ID=7744d716de1a8fe0:T=1453460495:S=ALNI_MbiMzOOdFmuYb2HUTJDcWSrJi1Orw; crtg_rta=; __utmb=160852194.1.10.1453715750; __utmt_siteTracker=1; _gat=1; bs=%7B%22st%22%3A%7B%7D%7D; __utmc=160852194'-- Webclient user agent Chrome
Cookie='ki_t=1453503651690%3B1453503651690%3B1453503651690%3B1%3B1; ki_r=; sc=L6Iqe9Nf4cQV4z2YtICU; machId=e4FCpRSrCOM7uCKvV8O-ShFg9NtQcLj0y45Yq6c39ph7sbyQ6snL8bLr4IHwIjo__NpVEDazltY8OsCqfol0ibV9Y5dKXCHRfrY9; up=%7B%22ln%22%3A%22563950035%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; optimizelyEndUserId=oeu1453503645486r0.02016498341432238; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22ie%22%7D; optimizelyBuckets=%7B%7D; __utma=160852194.1946999416.1453503647.1453723916.1453763655.8; __utmz=160852194.1453503647.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1946999416.1453503647; __gads=ID=7744d716de1a8fe0:T=1453460495:S=ALNI_MbiMzOOdFmuYb2HUTJDcWSrJi1Orw; crtg_rta=; __utmb=160852194.3.10.1453763655; bs=%7B%22st%22%3A%7B%7D%7D; __utmc=160852194; sid2=1f8b08000000000000003dcc410b82301880e1bff21d15e2735b6e165d160606e63c24ed6c356b38367181d0afcf5387f7f8bc94903d278472211923c8728274b7c60b299bf0b5cef519470289b6fe199608aa0381f400bad5224fe1384dce6873afed27e3db1c79810c92fadc35970d383b1aa8cc630c29dccc1c6df0eb8c6201d77ee867fb17d2abd7c9ab4189766158c6aad426bef107464029c19d000000'--safari use web client leixi
where ID in (44)

update AutoPostAdPostData
set
--sku='gdutjim_IPhone4',
price=630,
title='Brand New Iphone 5 16G white',
description='Totally brand new Iphone 5 16G White in sealed box for 630, unlocked.

Please rest your mind that it is from reliable channel. 

Only accept Pick up and Cash.',
--CategoryID=296,

ImagesPath='\Alvin\11\1.jpg;\Alvin\11\2.jpg;\Alvin\11\3.jpg;\Alvin\11\4.jpg;\Alvin\11\5.jpg;\Alvin\11\6.jpg;\Alvin\11\7.jpg;\Alvin\11\8.jpg;\Alvin\11\9.jpg;\Alvin\11\10.jpg'

where 
ID=1884




update AutoPostAdPostData
set
--AccountID=29,
--SKU='BS_Tom_Ken_Melbourne_Clean_3',
--Title='Star Wars Imperial Star Destroyer Lego 75055 New In Box ',
--Price=0,
--Description='

--LEGO Minecraft The Cave 21113 BRAND NEW SEALED

--Venture into The Cave on a dangerous quest for vital resources! Wield the iron pickaxe to dig and battle against hostile zombie and spider mobs. Blast out valuable ores and minerals with the TNT and combine the flowing water and lava to create precious obsidian! When you''re done battling and mining, restore your energy levels with the chest of bread. Proceed with caution! Rebuild the set for more LEGO Minecraft creations! Includes 2 minifigures with assorted accessories: Steve and a zombie, plus a spider.

--Pick up and cash only 

--Please feel free to email if interested. Will discuss meet time and place via mobile phone text.',
AccountID=44
--CategoryID=211,
--CustomFieldGroupID=2,
--ImagesPath='\Jim\2.jpg'
--BusinessLogoPath='\Sumit\1.png'
where 
--ID in (1881,1882,1878,1879)
SKU in ('Item_Jim_LEGO_MineCraftWholeSet')

select * from AutoPostAdPostData where sku like '%BS_Sumit_Melbourne_Assignment_1%'

select * from Account where ID=23


update CustomFieldLine set FieldValue='0451298902'
where ID=55


update AutoPostAdPostData
set 
--title='Unwanted gift, Brand New Canon EF-S 18-200mm f/3.5-5.6 IS Lens',
--Price=50,
--description=REPLACE(Description,'60','50')
--CategoryID=305,
--ImagesPath='\ShuFang\6.jpg;\ShuFang\7.jpg;\ShuFang\8.jpg;\ShuFang\9.jpg;\ShuFang\10.jpg;\ShuFang\11.jpg'
Status='D'
where SKU='Item_Jim_LEGO_71006'




select * from AutoPostAdPostData
where  Status='A'



begin try
select convert(xml,'<Orders><Order><ID>1</ID>')
end try

begin catch
print ERROR_MESSAGE()
end catch



PRINT @@TRANCOUNT

begin try
	begin tran
	waitfor delay '00:00:10'
	commit tran
end try
begin catch
	rollback tran
end catch

begin try
	begin tran
	select 1
	PRINT @@TRANCOUNT
	commit tran
end try
begin catch
	rollback tran
end catch





select * from AutoPostAdPostData where ImagesPath like '%F:\Jim\Own\LearningDoc\DailyDealsAggregator\Informations\GumtreePostAdData%' or BusinessLogoPath like '%F:\Jim\Own\LearningDoc\DailyDealsAggregator\Informations\GumtreePostAdData%'

update AutoPostAdPostData 
set ImagesPath=REPLACE(ImagesPath,'F:\Jim\Own\LearningDoc\DailyDealsAggregator\Informations\GumtreePostAdData',''),
BusinessLogoPath=REPLACE(BusinessLogoPath,'F:\Jim\Own\LearningDoc\DailyDealsAggregator\Informations\GumtreePostAdData','')
where ImagesPath like '%F:\Jim\Own\LearningDoc\DailyDealsAggregator\Informations\GumtreePostAdData%' or BusinessLogoPath like '%F:\Jim\Own\LearningDoc\DailyDealsAggregator\Informations\GumtreePostAdData%'


select * from V_ProductCategory where CategoryID=21009

select * from V_ProductCategory where ParentCategoryID=20022

select * from V_ProductCategory

select * from V_ProductCategory where ID in (27)

select * from V_ProuctCategoryDetail where ID in (154)

select * from AutoPostAdPostData where SKU like '%EGG-AUTO-60%'

select left('Helicopter Flight,Rally Driving,Hot Air Ballooning 10% off',65)

insert into AutoPostAdPostData
select 
'Item_Jim_Adrenalin',
90,
'Helicopter Flight,Rally Driving,Hot Air Ballooning 10% off',
80,
-1,
50,
44,
1,
'',
'
I am selling Adrenalin gift card for 10% off, the adventure experience company offers varis of exciting activities includes following:

Helicopter Flight/Rides
Rally Driving
Hot Air Ballooning
Jet Pack and Flyboard
Skydiving
European Supercars
Indoor Skydiving
Jet Boats Rides,
Quad Biking...

And many other great activities you might love. You can go to the Adrenalin website and see all the details.

All cards were bought with receipt and activation receipt and 100% brand new. Now you just need to choose the activities you like and get them further 10% off.

Pick up cash only. 

please contact me if you are insterested
',
'\Jim\Adrenalin\1.jpg;\Jim\Adrenalin\2.png;\Jim\Adrenalin\3.jpg;\Jim\Adrenalin\4.png;\Jim\Adrenalin\5.jpg',
'',
'A',
0,
'',
1,
1




select * from AutoPostAdPostData where SKU like '%Item_Jim%'


update AutoPostAdPostData
set 
--Title='Unwanted Gift Brand New Unlock HTC desire 510',
Description='
  All clothing alterations. 
 - Hems taken up or down 
 - All kind of clothes taken in or out 
 - Shortening & Lengthen (Jeans, work pants, Skirts etc.) 
 - Zips re-placed, repair and re adjust 
 - Buttons sew on 
 - Holes in pockets re- sewn 
 - Torn lining in coats, skirts etc re-sewn 
 - Kids clothes alteration, school dress, pants, skirts etc. 
 
Custom made your cushions, curtains, pillow cases and many more. Please feel free to ask me for any other kind of alterations or repairs that are not mentioned above.  

If you have any favorite clothing put in the cardboard long time! But still like it! Find me, I will give you special design and surprise for you!
 
Please do not send message via gumtree, please contact me on:
Email:fanrenjiyuwsf @ 126.com
Phone:0449850688
Name:Shufang
Address:9A King St, Rockdale NSW 2216
'
--ImagesPath='\Jim\Adrenalin\1.jpg;\Jim\Adrenalin\2.png;\Jim\Adrenalin\3.jpg;\Jim\Adrenalin\4.png;\Jim\Adrenalin\5.jpg'
--AddressID=51
where SKU in ('BS_ShuFang_NSW_Alteration')




select * from AutoPostAdPostData where SKU like '%jim%'


--delete/update ad ID by sku



--update R
--set AdID='1100143287'
select *
from AutoPostAdPostData D
inner join AutoPostAdResult R on D.ID=R.AutoPostAdDataID
where D.SKU='Item_Jim_Adrenalin'