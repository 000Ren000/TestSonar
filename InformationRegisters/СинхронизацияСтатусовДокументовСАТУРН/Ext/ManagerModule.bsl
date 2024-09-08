﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура УстановитьДатуВыполненияСинхронизации(ОрганизацияСАТУРН,
	ВидНастройкиОбмена = Неопределено, ДатаСинхронизации = Неопределено, ПроверятьРегистр = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ОрганизацияСАТУРН.Установить(ОрганизацияСАТУРН);
	НаборЗаписей.Отбор.ВидНастройкиОбмена.Установить(ВидНастройкиОбмена);
	
	Если ДатаСинхронизации <> Неопределено Тогда
		
		Если ПроверятьРегистр Тогда
			НаборЗаписей.Прочитать();
			Если НаборЗаписей.Выбран()
				И НаборЗаписей.Количество() > 0 Тогда
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
		ЗаписьНабора = НаборЗаписей.Добавить();
		ЗаписьНабора.ОрганизацияСАТУРН  = ОрганизацияСАТУРН;
		ЗаписьНабора.ВидНастройкиОбмена = ВидНастройкиОбмена;
		ЗаписьНабора.ДатаСинхронизации  = ДатаСинхронизации;
		ЗаписьНабора.ДатаОбмена         = ТекущаяУниверсальнаяДата();
		
		НаборЗаписей.Записать();
		
	Иначе
		
		НаборЗаписей.Прочитать();
		Если НаборЗаписей.Выбран()
			И НаборЗаписей.Количество() > 0 Тогда
			
			Для Каждого ЗаписьНабора Из НаборЗаписей Цикл
				ЗаписьНабора.ДатаОбмена = ТекущаяУниверсальнаяДата();
			КонецЦикла;
			
			НаборЗаписей.Записать();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ДатаСинхронизации(ОрганизацияСАТУРН, ВидНастройкиОбмена) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст ="ВЫБРАТЬ
	|	СинхронизацияСтатусовДокументовСАТУРН.ДатаСинхронизации КАК ДатаСинхронизации
	|ИЗ
	|	РегистрСведений.СинхронизацияСтатусовДокументовСАТУРН КАК СинхронизацияСтатусовДокументовСАТУРН
	|ГДЕ
	|	СинхронизацияСтатусовДокументовСАТУРН.ОрганизацияСАТУРН = &ОрганизацияСАТУРН
	|	И СинхронизацияСтатусовДокументовСАТУРН.ВидНастройкиОбмена = &ВидНастройкиОбмена";
	
	Запрос.УстановитьПараметр("ОрганизацияСАТУРН",  ОрганизацияСАТУРН);
	Запрос.УстановитьПараметр("ВидНастройкиОбмена", ВидНастройкиОбмена);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Дата(1,1,1);
	Иначе
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.ДатаСинхронизации;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецЕсли