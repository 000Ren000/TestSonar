﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Функция ДоступныеРеквизиты(ИдентификаторДокумента, ТипДокумента) Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИдентификаторДокумента" , ИдентификаторДокумента);
	Запрос.УстановитьПараметр("ТипДокумента"           , ТипДокумента);
	Запрос.Текст = "ВЫБРАТЬ
	               |	ДоступныеДляРедактированияРеквизитыДокументовEDI.ИмяРеквизита КАК ИмяРеквизита
	               |ИЗ
	               |	РегистрСведений.ДоступныеДляРедактированияРеквизитыДокументовEDI КАК ДоступныеДляРедактированияРеквизитыДокументовEDI
	               |ГДЕ
	               |	ДоступныеДляРедактированияРеквизитыДокументовEDI.ИдентификаторДокумента = &ИдентификаторДокумента
	               |	И ДоступныеДляРедактированияРеквизитыДокументовEDI.ТипДокумента = &ТипДокумента";
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ИмяРеквизита");
	
КонецФункции

Процедура ЗаписатьДоступныеРеквизиты(ИдентификаторДокумента, ТипДокумента, НаборРеквизитов) Экспорт 
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
	
	Попытка
		
		БлокировкаДанных = Новый БлокировкаДанных;
		
		ЭлементБлокировкиДанных = БлокировкаДанных.Добавить("РегистрСведений.ДоступныеДляРедактированияРеквизитыДокументовEDI");
		ЭлементБлокировкиДанных.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировкиДанных.УстановитьЗначение("ИдентификаторДокумента" , ИдентификаторДокумента);
		ЭлементБлокировкиДанных.УстановитьЗначение("ТипДокумента"           , ТипДокумента);
		
		БлокировкаДанных.Заблокировать();
		
		НаборЗаписей = РегистрыСведений.ДоступныеДляРедактированияРеквизитыДокументовEDI.СоздатьНаборЗаписей();
		
		Для каждого ИмяРеквизита Из НаборРеквизитов Цикл
			
			НоваяЗапись = НаборЗаписей.Добавить();
			НоваяЗапись.ИдентификаторДокумента = ИдентификаторДокумента;
			НоваяЗапись.ТипДокумента           = ТипДокумента;
			НоваяЗапись.ИмяРеквизита           = ИмяРеквизита;
			
		КонецЦикла;
		
		НаборЗаписей.Записать(Истина);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ТекстИсключения = СтрШаблон(НСтр("ru = 'Не удалось записать доступные реквизиты документа по причине: %1.'"),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ВызватьИсключение(ТекстИсключения);
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
