﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Перем СписокПолейДляРасшифровки;
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Запись.ИсходныйКлючЗаписи.Пустой() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Проверка", 		   Запись.Проверка);
	Запрос.УстановитьПараметр("Организация", 	   Запись.Организация);
	Запрос.УстановитьПараметр("ПроверяемыйПериод", Запись.ПроверяемыйПериод);
	Запрос.УстановитьПараметр("Проблема", 		   Запись.Проблема);
	Запрос.УстановитьПараметр("СоставнойОбъект",   Запись.СоставнойОбъект);
	
	// Заполнение представления проблемы.
	Если ЗначениеЗаполнено(Запись.Представление) Тогда
		
		ПредставлениеПроблемы = Запись.Представление;
		
	Иначе
		
		Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ПроблемыСостоянияСистемы.Представление
		|ИЗ
		|	РегистрСведений.ПроблемыСостоянияСистемы КАК ПроблемыСостоянияСистемы
		|ГДЕ
		|	ПроблемыСостоянияСистемы.Проблема = &Проблема";
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			ПредставлениеПроблемы = Выборка.Представление;
		Иначе
			ПредставлениеПроблемы = НСтр("ru='не удалось нийти описание проблемы'");
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Запись.Объект) Тогда
		
		Элементы.Объект.Видимость = Истина;
		Элементы.Расшифровка.Видимость = Ложь;
		Элементы.ПредставлениеРегистраДляРасшифровки.Видимость = Ложь;
		
	Иначе
		
		Элементы.Объект.Видимость = Ложь;
		Элементы.Расшифровка.Видимость = Истина;
		
		// Заполнение расшифровки.
		Расшифровка.Очистить();
		
		Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ОбъектыПроблемСостоянияСистемы.ПроверяемыйПериод КАК Период,
		|	ОбъектыПроблемСостоянияСистемы.РасшифровкаСоставногоОбъекта
		|ИЗ
		|	РегистрСведений.ОбъектыПроблемСостоянияСистемы КАК ОбъектыПроблемСостоянияСистемы
		|ГДЕ
		|	ОбъектыПроблемСостоянияСистемы.Проблема = &Проблема
		|	И ОбъектыПроблемСостоянияСистемы.СоставнойОбъект = &СоставнойОбъект";
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		ПараметрыФормыРасшифровки = Новый Структура;
		
		Если Выборка.Следующий() Тогда
			
			ПараметрыФормыРасшифровки.Вставить(ЗакрытиеМесяцаСервер.ИмяСлужебногоСвойстваОткрываемыхФорм(), Истина);
			ПараметрыФормыРасшифровки.Вставить("ОтборДляРасшифровки", Новый Структура);
			ПараметрыФормыРасшифровки.ОтборДляРасшифровки.Вставить("Период", Выборка.Период);
			
			РасшифровкаСоставногоОбъекта = Выборка.РасшифровкаСоставногоОбъекта; // ХранилищеЗначения
			ДопИнформация = РасшифровкаСоставногоОбъекта.Получить();
			
			Если ТипЗнч(ДопИнформация) = Тип("Структура") ИЛИ ТипЗнч(ДопИнформация) = Тип("ФиксированнаяСтруктура") Тогда
				
				ТипВсеСсылки = ОбщегоНазначения.ОписаниеТипаВсеСсылки();
				
				ДопИнформация.Свойство("СписокПолейДляРасшифровки", СписокПолейДляРасшифровки);
				
				Для Каждого КлючИЗначение Из ДопИнформация Цикл
					
					Если КлючИЗначение.Ключ = "ИмяРегистраДляРасшифровки" Тогда
						
						МетаданныеРегистраДляРасшифровки = Метаданные.НайтиПоПолномуИмени(КлючИЗначение.Значение);
						
						Если МетаданныеРегистраДляРасшифровки <> Неопределено Тогда
							
							ИмяРегистраДляРасшифровки = КлючИЗначение.Значение;
							
							ПредставлениеРегистраДляРасшифровки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								НСтр("ru='Открыть форму списка регистра ""%1"".'"),
								МетаданныеРегистраДляРасшифровки.Синоним);
							
						КонецЕсли;
							
					ИначеЕсли КлючИЗначение.Ключ = "СписокПолейДляРасшифровки" Тогда
						// пропустим
					Иначе
						
						Если ТипВсеСсылки.СодержитТип(ТипЗнч(КлючИЗначение.Значение)) Тогда
							
							Если ЗначениеЗаполнено(КлючИЗначение.Значение) Тогда 
								
								ПредставлениеПоля = КлючИЗначение.Ключ;
								
								Если СписокПолейДляРасшифровки <> Неопределено Тогда
									
									ОписаниеПоля = СписокПолейДляРасшифровки.НайтиПоЗначению(КлючИЗначение.Ключ);
									Если ОписаниеПоля <> Неопределено И ЗначениеЗаполнено(ОписаниеПоля.Представление) Тогда
										ПредставлениеПоля = ОписаниеПоля.Представление;
									КонецЕсли;
									
								КонецЕсли;
								
								Расшифровка.Добавить(КлючИЗначение.Значение, ПредставлениеПоля + ": " + КлючИЗначение.Значение);
								
							КонецЕсли;
							
							ПараметрыФормыРасшифровки.ОтборДляРасшифровки.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
							
						КонецЕсли;
						
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;
		
		ПараметрыФормыРасшифровки.Вставить("ОтборДляРасшифровки", Новый ФиксированнаяСтруктура(ПараметрыФормыРасшифровки.ОтборДляРасшифровки));
		ПараметрыФормыРасшифровки = Новый ФиксированнаяСтруктура(ПараметрыФормыРасшифровки);
		
	КонецЕсли;
	
	Элементы.ПредставлениеРегистраДляРасшифровки.Видимость = ЗначениеЗаполнено(ПредставлениеРегистраДляРасшифровки);
	
	// Получение даты последней проверки.
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВыполнениеПроверокСостоянияСистемы.ДатаВыполнения
	|ИЗ
	|	РегистрСведений.ВыполнениеПроверокСостоянияСистемы КАК ВыполнениеПроверокСостоянияСистемы
	|ГДЕ
	|	ВыполнениеПроверокСостоянияСистемы.Проверка = &Проверка
	|	И ВыполнениеПроверокСостоянияСистемы.Организация = &Организация
	|	И ВыполнениеПроверокСостоянияСистемы.ПроверяемыйПериод = &ПроверяемыйПериод";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ДатаПроверки = Формат(Выборка.ДатаВыполнения, "ДЛФ=DT");
	Иначе
		ДатаПроверки = НСтр("ru='не удалось определить дату проверки'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РасшифровкаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПоказатьЗначение(, Расшифровка[ВыбраннаяСтрока].Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеРегистраДляРасшифровкиНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОткрытьФорму(ИмяРегистраДляРасшифровки + ".ФормаСписка", Новый Структура(ПараметрыФормыРасшифровки));
	
КонецПроцедуры

#КонецОбласти
