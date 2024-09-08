﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Возможность преобразовать указанный пользователем телефонный номер, в формат, который принимает провайдер отправки SMS
//
// Параметры:
//  Номер             - Строка - телефонный номер, указанный пользователем,
//  НомерДляОтправки  - Строка - в данный параметр помещается результат преобразования
//
Процедура ПриФорматированииТелефонногоНомераДляОтправки(Номер, НомерДляОтправки) Экспорт
	
	// Локализация
	Результат = "";
	ДопустимыеСимволы = "+1234567890";
	Для Позиция = 1 По СтрДлина(Номер) Цикл
		Символ = Сред(Номер,Позиция,1);
		Если СтрНайти(ДопустимыеСимволы, Символ) > 0 Тогда
			Результат = Результат + Символ;
		КонецЕсли;
	КонецЦикла;
	
	Если СтрДлина(Результат) > 10 Тогда
		ПервыйСимвол = Лев(Результат, 1);
		Если ПервыйСимвол = "8" Тогда
			Результат = "+7" + Сред(Результат, 2);
		ИначеЕсли ПервыйСимвол <> "+" Тогда
			Результат = "+" + Результат;
		КонецЕсли;
	КонецЕсли;
	
	НомерДляОтправки = Результат;
	// Конец Локализация
	
КонецПроцедуры

// Возможность дополнить массив имен папок, которые будут игнорироваться при загрузке писем с почтового сервера по
// протоколу IMAP.
//
// Параметры:
//  ИменаПапок        - Массив Из Строка - массив имен игнорируемых папок.
//  
Процедура ПриОпределенииИгнорируемыхИменПапокПриЗагрузкеПисем(ИменаПапок) Экспорт
	
	// Локализация
	ИменаПапок.Добавить("спам");
	ИменаПапок.Добавить("удаленные");
	ИменаПапок.Добавить("черновики");
	ИменаПапок.Добавить("корзина");
	// Конец Локализация
	
КонецПроцедуры

// Дополняет соответствие идентичных (подменяемых) доменов электронной почты.
// Используется при определении того, что письмо отправлено на почтовый ящик отправителя.
// Может потребоваться при загрузке исходящего письма по протоколу IMAP.
// При отправке такого письма почтовый сервер мог указать в адресе отправителя другой домен.
// 
// Параметры:
//  СинонимыДоменовЭлектроннойПочты - Соответствие - где ключ имя, которое нужно заменить,
//    а значение имя домена, на который нужно заменить.
//
Процедура ПриОпределенииСинонимовДоменовЭлектроннойПочты(СинонимыДоменовЭлектроннойПочты) Экспорт
	
	// Локализация
	СинонимыДоменовЭлектроннойПочты.Вставить("yandex.ru","ya.ru");
	// Конец Локализация
	
КонецПроцедуры

#КонецОбласти

