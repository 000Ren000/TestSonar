﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Функция НаборКомандПоУмолчанию(ТипДокумента) Экспорт
	
	НаборКоманд = Новый Соответствие;
	Если ТипДокумента = Перечисления.ТипыДокументовEDI.ЗаказПоставщику Тогда
		ДанныеКоманды = Новый Структура;
		ДанныеКоманды.Вставить("Представление"         , НСтр("ru = 'Отправить заказ'"));
		ДанныеКоманды.Вставить("Пояснение"             , "");
		ДанныеКоманды.Вставить("Картинка"              , Новый Картинка);
		ДанныеКоманды.Вставить("ОсновнаяКоманда"       , Истина);
		ДанныеКоманды.Вставить("Порядок"               , 1);
		ДанныеКоманды.Вставить("СценарийВыполнения"    , Перечисления.СценарииВыполненияКомандEDI.СоздатьДокументВСервисе);
		ДанныеКоманды.Вставить("КлиентскиеОбработчики" , Новый Массив);
		
		НаборКоманд.Вставить(Перечисления.КомандыПроцессаЗаказаEDI.СоздатьЗаказПоставщику,
			ДанныеКоманды);
	КонецЕсли;
	
	Возврат НаборКоманд;
	
КонецФункции

Функция ПрочитатьКомандыДокумента(ИдентификаторДокумента, ТипДокумента) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КомандыДокументовEDI.Команда КАК Команда,
	|	КомандыДокументовEDI.Представление КАК Представление,
	|	КомандыДокументовEDI.Пояснение КАК Пояснение,
	|	КомандыДокументовEDI.ИдентификаторКартинки КАК ИдентификаторКартинки,
	|	КомандыДокументовEDI.ОсновнаяКоманда КАК ОсновнаяКоманда,
	|	КомандыДокументовEDI.Порядок КАК Порядок,
	|	КомандыДокументовEDI.СценарийВыполнения КАК СценарийВыполнения,
	|	КомандыДокументовEDI.КлиентскиеОбработчики КАК КлиентскиеОбработчикиСтрока,
	|	КомандыДокументовEDI.URL КАК URL
	|ИЗ
	|	РегистрСведений.КомандыДокументовEDI КАК КомандыДокументовEDI
	|ГДЕ
	|	КомандыДокументовEDI.ИдентификаторДокумента = &ИдентификаторДокумента
	|	И КомандыДокументовEDI.ТипДокумента = &ТипДокумента";
	
	Запрос.УстановитьПараметр("ИдентификаторДокумента" , ИдентификаторДокумента);
	Запрос.УстановитьПараметр("ТипДокумента"           , ТипДокумента);
	
	НаборКоманд = Новый Соответствие;
	
	ВыборкаЗапроса = Запрос.Выполнить().Выбрать();
	
	Пока ВыборкаЗапроса.Следующий() Цикл
		
		ДанныеКоманды = Новый Структура("Представление, Пояснение, ИдентификаторКартинки, Картинка, ОсновнаяКоманда, 
			|Порядок, СценарийВыполнения, КлиентскиеОбработчики, URL");
		
		ЗаполнитьЗначенияСвойств(ДанныеКоманды, ВыборкаЗапроса);
		
		Если Не ЗначениеЗаполнено(ДанныеКоманды.ИдентификаторКартинки) Тогда
			ДанныеКоманды.Картинка = Новый Картинка;
		ИначеЕсли Метаданные.ОбщиеКартинки.Найти(ДанныеКоманды.ИдентификаторКартинки) = Неопределено Тогда
			ДанныеКоманды.Картинка = Новый Картинка;
		Иначе
			ДанныеКоманды.Картинка = БиблиотекаКартинок[ДанныеКоманды.ИдентификаторКартинки];
		КонецЕсли;
		
		ДанныеКоманды.КлиентскиеОбработчики = СтрРазделить(ВыборкаЗапроса.КлиентскиеОбработчикиСтрока, ",");
		
		НаборКоманд.Вставить(ВыборкаЗапроса.Команда, ДанныеКоманды);
		
	КонецЦикла;
	
	Возврат НаборКоманд;
	
КонецФункции

Процедура УстановитьКомандыДокумента(ИдентификаторДокумента, ТипДокумента, НаборКоманд) Экспорт
	
	ЗаписатьКомандыДокумента(ИдентификаторДокумента, ТипДокумента, НаборКоманд);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаписатьКомандыДокумента(ИдентификаторДокумента, ТипДокумента, НаборКоманд)
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
	
	Попытка
		
		БлокировкаДанных = Новый БлокировкаДанных;
		
		ЭлементБлокировкиДанных = БлокировкаДанных.Добавить("РегистрСведений.КомандыДокументовEDI");
		ЭлементБлокировкиДанных.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировкиДанных.УстановитьЗначение("ИдентификаторДокумента" , ИдентификаторДокумента);
		ЭлементБлокировкиДанных.УстановитьЗначение("ТипДокумента"           , ТипДокумента);
		
		БлокировкаДанных.Заблокировать();
		
		НаборЗаписей = РегистрыСведений.КомандыДокументовEDI.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ИдентификаторДокумента.Установить(ИдентификаторДокумента);
		НаборЗаписей.Отбор.ТипДокумента.Установить(ТипДокумента);
		
		НомерКоманды = 0;
		
		Для каждого КомандаНабора Из НаборКоманд Цикл
			
			НомерКоманды = НомерКоманды + 1;
			
			НоваяЗапись = НаборЗаписей.Добавить();
			НоваяЗапись.ИдентификаторДокумента = ИдентификаторДокумента;
			НоваяЗапись.ТипДокумента           = ТипДокумента;
			НоваяЗапись.Команда                = КомандаНабора.Ключ;
			НоваяЗапись.URL                    = КомандаНабора.Значение.URL;
			
			Если ЗначениеЗаполнено(КомандаНабора.Значение.КлиентскиеОбработчики) Тогда
				НоваяЗапись.КлиентскиеОбработчики  = СтрСоединить(КомандаНабора.Значение.КлиентскиеОбработчики, ",");
			КонецЕсли;
			
			ЗаполнитьЗначенияСвойств(НоваяЗапись, КомандаНабора.Значение, , "КлиентскиеОбработчики");
			
		КонецЦикла;
		
		НаборЗаписей.Записать(Истина);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ТекстИсключения = СтрШаблон(НСтр("ru = 'Не удалось записать команды документа по причине: %1.'"),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ВызватьИсключение(ТекстИсключения);
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
