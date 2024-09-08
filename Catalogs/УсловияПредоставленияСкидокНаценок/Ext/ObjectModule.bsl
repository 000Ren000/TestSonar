﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если УсловиеПредоставления <> Перечисления.УсловияПредоставленияСкидокНаценок.ЗаВремяПродажи Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ВремяДействия");
	КонецЕсли;
	
	Если УсловиеПредоставления <> Перечисления.УсловияПредоставленияСкидокНаценок.КартаЛояльностиНеЗарегистрирована Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ВидКартыЛояльности");
	КонецЕсли;
	
	Если УсловиеПредоставления <> Перечисления.УсловияПредоставленияСкидокНаценок.ОграничениеПоГруппеПользователей Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ГруппаПользователей");
	КонецЕсли;
	
	Если УсловиеПредоставления <> Перечисления.УсловияПредоставленияСкидокНаценок.ЗаНакопленныйОбъемПродаж 
		И УсловиеПредоставления <> Перечисления.УсловияПредоставленияСкидокНаценок.ЗаРазовыйОбъемПродаж Тогда
	
		МассивНепроверяемыхРеквизитов.Добавить("КритерийОграниченияПримененияЗаОбъемПродаж");
		МассивНепроверяемыхРеквизитов.Добавить("ТипСравнения");
		МассивНепроверяемыхРеквизитов.Добавить("ВалютаОграничения");
		МассивНепроверяемыхРеквизитов.Добавить("СегментНоменклатурыОграничения");
		
	Иначе
		
		Если КритерийОграниченияПримененияЗаОбъемПродаж <> Перечисления.КритерииОграниченияПримененияСкидкиНаценкиЗаОбъемПродаж.Сумма Тогда
			МассивНепроверяемыхРеквизитов.Добавить("ВалютаОграничения");
		КонецЕсли;
		
		Если ВариантОтбораНоменклатуры <> Перечисления.ВариантыОтбораНоменклатурыДляРасчетаСкидокНаценок.СегментНоменклатуры Тогда
			МассивНепроверяемыхРеквизитов.Добавить("СегментНоменклатурыОграничения");
		КонецЕсли;
		
	КонецЕсли;
	
	Если УсловиеПредоставления <> Перечисления.УсловияПредоставленияСкидокНаценок.ЗаНакопленныйОбъемПродаж Тогда
	
		МассивНепроверяемыхРеквизитов.Добавить("ВариантНакопления");
		МассивНепроверяемыхРеквизитов.Добавить("ВариантОпределенияПериодаНакопительнойСкидки");
		МассивНепроверяемыхРеквизитов.Добавить("ПериодНакопления");
		МассивНепроверяемыхРеквизитов.Добавить("КоличествоПериодовНакопления");
		
	Иначе
		
		Если ВариантОпределенияПериодаНакопительнойСкидки <> Перечисления.ВариантыОпределенияПериодаНакопительнойСкидки.ВесьПериод Тогда
			МассивНепроверяемыхРеквизитов.Добавить("ПериодНакопления");
		КонецЕсли;
		
	КонецЕсли;
	
	Если УсловиеПредоставления <> Перечисления.УсловияПредоставленияСкидокНаценок.ЗаРазовыйОбъемПродаж Тогда
	
		МассивНепроверяемыхРеквизитов.Добавить("КритерийОграниченияПримененияЗаОбъемПродаж");
		
	КонецЕсли;
	
	Если УсловиеПредоставления <> Перечисления.УсловияПредоставленияСкидокНаценок.ВхождениеПартнераВСегмент Тогда
	
		МассивНепроверяемыхРеквизитов.Добавить("СегментПартнеров");
		
	КонецЕсли;
	
	ШаблонОшибка = НСтр("ru = 'Время окончания действия скидки (наценки )меньше времени начала в строке %НомерСтроки%'");
	Для Каждого СтрокаТаб Из ВремяДействия Цикл
		
		Если СтрокаТаб.ВремяОкончания < СтрокаТаб.ВремяНачала Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрЗаменить(ШаблонОшибка, "%НомерСтроки%", Строка(СтрокаТаб.НомерСтроки)),
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ВремяДействия", СтрокаТаб.НомерСтроки, "ВремяОкончания"),
				,
				Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если Не ЭтоГруппа Тогда
		ВалютаОграничения = ДоходыИРасходыСервер.ПолучитьВалютуУправленческогоУчета(ВалютаОграничения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	СкидкиНаценкиСервер.ПередЗаписью(ЭтотОбъект, Отказ);
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	СкидкиНаценкиКлиентСервер.ОчиститьРеквизитыВЗависимостиОтУсловияПрименения(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
