﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования) 
	
	ОписанияСценария.Очистить();

КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоНовый() И Не ЗначениеЗаполнено(Код) Тогда
		УстановитьНовыйКод();
	КонецЕсли;
	
	Если ПометкаУдаления Тогда
		ОписанияСценария.Очистить();
	КонецЕсли;
	
	Если Не (ДополнительныеСвойства.Свойство("НеПересчитыватьПолныйКодСправочника")
		И ДополнительныеСвойства.НеПересчитыватьПолныйКодСправочника = Истина) Тогда
	
		УстановитьПолныйКодСправочника(ЭтотОбъект, 3);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьПолныйКодСправочника(Объект, КоличествоРазрядов = 0) Экспорт
	
	Если КоличествоРазрядов > 0 Тогда
		Код = Формат(Число(Объект.Код), "ЧЦ=" + КоличествоРазрядов + "; ЧВН=");
	Иначе
		Код = Объект.Код;
	КонецЕсли;
	
	Если НЕ Объект.Родитель.Пустая() Тогда
		Объект.ПолныйКод = СокрЛП(ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Родитель, "ПолныйКод").ПолныйКод) + "." + Код;
	Иначе
		Объект.ПолныйКод = Код;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЧтенииПредставленийНаСервере() Экспорт 
	
	МультиязычностьСервер.ПриЧтенииПредставленийНаСервере(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли