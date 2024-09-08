﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Функция ДанныеДокументаСервиса(ПараметрыКоманды) Экспорт
	
	ДанныеДокументаСервиса = РаботаСДаннымиEDIСлужебный.ДанныеДокументаСервиса(ПараметрыКоманды);
	
	Если ДанныеДокументаСервиса.Ошибка Тогда
		Возврат ДанныеДокументаСервиса;
	КонецЕсли;
	
	ДанныеСервиса = ДанныеДокументаСервиса.Данные;
	
	Кэш = РегистрыСведений.СостоянияДокументовEDI.ДанныеПрикладногоОбъектаПоДаннымСервиса(ДанныеСервиса.ИдентификаторВСервисе, ДанныеСервиса.ТипДокумента);
	Если Кэш = Неопределено Тогда
		ДанныеСервиса = РаботаСДаннымиEDIСлужебный.АктуальноеСостояниеДокумента(ПараметрыКоманды);
	КонецЕсли;
		
	Результат = РегистрыСведений.СостоянияДокументовEDI.ОбновленныеДанныеЗаписиРеестра(ДанныеСервиса);
	
	// Обновление кэша доступных команд
	РегистрыСведений.КомандыДокументовEDI.УстановитьКомандыДокумента(
		ДанныеСервиса.ИдентификаторВСервисе, ДанныеСервиса.ТипДокумента, ДанныеСервиса.Команды);
		
	// Обновление кэша доступных реквизитов
	РегистрыСведений.ДоступныеДляРедактированияРеквизитыДокументовEDI.ЗаписатьДоступныеРеквизиты(
		ДанныеСервиса.ИдентификаторВСервисе, ДанныеСервиса.ТипДокумента, ДанныеСервиса.ДоступныеРеквизиты);
		
	// Добавление доступных команд к данным записи реестра
	Результат.Вставить("Команды", ДанныеСервиса.Команды);
	
	// Добавление доступных для изменения атрибутов модели
	Результат.Вставить("ДоступныеРеквизиты", ДанныеСервиса.ДоступныеРеквизиты);
	
	Возврат ДанныеДокументаСервиса;
	
КонецФункции

#КонецОбласти

#КонецЕсли
